class Client < ActiveRecord::Base
  include ActiveModel::Validations
  include BooleanRender

  HumanizedAttributes = { :lastName => "Last name",
                          :mi => "Middle initial",
                          :firstName => "First name",
                          :headOfHousehold => "Head of household?"}

  Races = { "AA" => "African American",
            "AS" => "Asian",
            "HI" => "Hispanic",
            "WH" => "White",
            "OT" => "Other" }

  AgeGroups = { "infant" => (0..5),
                "youth" => (6..17),
                "adult" => (18..64),
                "senior adult" => (65..74),
                "elder" => (75..120) }

  def self.age_group_empty_groups
    (AgeGroups.keys << "unknown").inject({}){|hash, key| hash[key.pluralize.sub(/ /,'_').to_sym] = []; hash}
  end

  def self.race_empty_groups
    (Races.keys << "Unknown" << "Total").inject({}){|hash, key| hash[key] = []; hash}
  end

  def self.age_group_base_count
    (AgeGroups.keys << "unknown").inject({}){|hash, key| hash[key.pluralize.sub(/ /,'_').to_sym] = 0; hash}
  end

  default_scope order('case when birthdate IS NULL then 1 else 0 end, birthdate')

  belongs_to :household
  delegate :with_errors, :to => :household, :prefix => true
  delegate :upload_link_text, :qualification_error_message, :qualification_vector, :current?, :confirm, :warnings, :vi, :confirm=, :warnings=, :vi=, :to => :id_qualdoc, :prefix => :id
  delegate_multiparameter :date, :to => :id_qualdoc, :prefix => :id

  has_one :id_qualdoc, :foreign_key => :association_id, :dependent => :destroy, :autosave => true
  has_many :checkins, :dependent => :destroy, :autosave => true

  validates :firstName, :lastName, :presence => true

  class UniqueClientValidator < ActiveModel::Validator
    def validate(record)
      if record.new_record? && Client.exists?( :firstName => record.firstName, :lastName => record.lastName, :birthdate => record.birthdate )
        record.errors[:base] << "#{record.first_last_name} is already in the database"
      end
    end
  end
  validates_with UniqueClientValidator

  # note, no client-side validation for birthdate, it's not supported by the client_side_validations gem
  validates :birthdate, :presence => true, :inclusion => { :if => Proc.new{|client| !client.birthdate.blank?}, :in => 120.years.ago..Date.today, :message => "cannot be in the future" }


  def self.human_attribute_name(attr, options = {})
    HumanizedAttributes[attr.to_sym] || super
  end

  # returns just the matching lastnames, to populate the search form
  # for household search
  def self.lastNames_matching(lastName)
    select(:lastName).
      where("lastName LIKE '%#{lastName.gsub("'","''")}%'").
      map(&:lastName).
      uniq.compact.sort.
      reject(&:blank?)
  end

  # returns matching lastname and id, for quickcheck
  def self.lastNames_matching_extended(lastName)
    select([:id, :lastName, :firstName, :birthdate]).
      where("lastName LIKE '%#{lastName.gsub("'","''")}%'").
      map{|c| c.name_age + '|' + c.id.to_s}.
      uniq.compact.sort.
      reject(&:blank?)
  end

  def self.with_no_household
    where(:household_id => nil)
  end

  def self.with_no_address
    Household.with_no_addresses.map(&:clients).flatten.uniq.sort_by(&:last_first_name)
  end

  def self.with_no_first_or_last_name
    where(:firstName => nil, :lastName => nil).map(&:household).compact.uniq
  end

  def has_report_errors
    birthdate.nil? || race.nil? || gender.nil? || (age_group == "out of range")
  end

  def race_or_unknown
    !race || (race == 'OT') ? 'UNK' : race
  end

  def name_age
    [last_first_name, age].reject(&:blank?).compact.join('. ')
  end

  def last_first_name
    [lastName || "(No last name)", firstName || "(No first name)"].join(", ")
  end

  def first_last_name
    [firstName || "(No first name)", lastName || "(No last name)"].join(" ")
  end

  def age
    ( ( Date.today - birthdate.to_date )/365 ).to_i unless birthdate.nil?
  end

  def age_group
    group = case age
            when nil
              "unknown"
            when AgeGroups['infant']
              "infant"
            when AgeGroups['youth']
              "youth"
            when AgeGroups['adult']
              "adult"
            when AgeGroups['senior adult']
              "senior adult"
            when AgeGroups['elder']
              "elder"
            else
              "out of range" # because the legacy database may have anomalous data
            end

    def group.to_key
      self.pluralize.gsub(/ /,'_').to_sym
    end
    group
  end

  def adult
    age >= 18 unless !age
  end

  def child
    age < 18 unless !age
  end

  def male
    gender == "M" unless !gender
  end

  def female
    gender == "F" unless !gender
  end

  def has_id_doc_in_db?
    id_qualdoc && id_qualdoc.in_db?
  end

  def docfile_exists?
    id_qualdoc &&
      id_qualdoc.docfile &&
      id_qualdoc.docfile.current_path &&
      File.exists?(id_qualdoc.docfile.current_path)
  end

  def is_sole_head_of_household?
    headOfHousehold? && household && household.has_single_head?
  end

  def household_size
    household.resident_count
  end

  def missing_gender_flag
    "x" unless gender
  end

  def missing_race_flag
    "x" unless race
  end

  def missing_birthdate_flag
    "x" unless birthdate
  end
end
