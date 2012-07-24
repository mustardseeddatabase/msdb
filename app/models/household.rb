class Household < ActiveRecord::Base

  include BooleanRender

  attr_accessor :matching_address

  DistributionColorCodes = ['','red','yellow','green','purple','blue','gray'] # indexed by number of residents

  IncomeRanges = {
                  "Under $10,000" => (0..9999),
                  "$10,000 - $24,999" => (10000..24999),
                  "$25,000 - $34,999" => (25000..34999),
                  "$35,000 - $49,999" => (35000..49999),
                  "$50,000 and above" => (50000..9999999999999999999999999999),
                  "Unknown" => nil
                 }

  def self.blank_income_range_count
    IncomeRanges.keys.inject({}){|hash,range| hash[range] = {:household_count => 0, :resident_count => 0}; hash}
  end

  def income_range
    case income
    when IncomeRanges["Under $10,000"]
      "Under $10,000"
    when IncomeRanges["$10,000 - $24,999"]
      "$10,000 - $24,999"
    when IncomeRanges["$25,000 - $34,999"]
      "$25,000 - $34,999"
    when IncomeRanges["$35,000 - $49,999"]
      "$35,000 - $49,999"
    when IncomeRanges["$50,000 and above"]
      "$50,000 and above"
    when nil
      "Unknown"
    end
  end

  has_many :clients
  has_many :distributions

  with_options :dependent => :destroy, :autosave => true do |h|
    [:perm_address, :temp_address].each{|pt| h.belongs_to pt}
  end
  accepts_nested_attributes_for :perm_address, :temp_address

  with_options :foreign_key => :association_id, :dependent => :destroy, :autosave => true do |h|
    [:res_qualdoc, :inc_qualdoc, :gov_qualdoc].each{|t| h.has_one t}
  end
  accepts_nested_attributes_for :res_qualdoc, :inc_qualdoc, :gov_qualdoc

  [:address, :city, :zip, :apt, :address=, :city=, :zip=, :apt=].each do |attr|
    delegate attr, :to => :perm_address, :prefix => :permanent, :allow_nil => true
    delegate attr, :to => :temp_address, :prefix => :temporary, :allow_nil => true
  end

  [:upload_link_text, :qualification_error_message, :qualification_vector, :current?, :confirm, :warnings, :vi, :confirm=, :warnings=, :vi=].each do |attr|
    delegate attr, :to => :res_qualdoc, :prefix => :res, :allow_nil => true
    delegate attr, :to => :inc_qualdoc, :prefix => :inc, :allow_nil => true
    delegate attr, :to => :gov_qualdoc, :prefix => :gov, :allow_nil => true
  end

  delegate_multiparameter :date, :to => :res_qualdoc, :prefix => :res
  delegate_multiparameter :date, :to => :inc_qualdoc, :prefix => :inc
  delegate_multiparameter :date, :to => :gov_qualdoc, :prefix => :gov

  # type is either :temp or :perm, search_obj is an object of type HouseholdSearch
  scope :with_address_matching, lambda{|type, search_obj | matching_fields(type, search_obj) }

  # not speed optimized, but intended only for admin, db checking
  def self.with_no_head
    includes(:perm_address, :temp_address, :clients).
      all.
      select(&:has_no_head?).
      sort_by{|h| [(h.perm_address || Address.new), (h.temp_address || Address.new)]}
  end

  # not speed optimized, but intended only for admin, db checking
  def self.with_multiple_heads
    includes(:perm_address, :temp_address, :clients).
      all.
      select(&:has_multiple_heads?).
      sort_by{|h| [(h.perm_address || Address.new), (h.temp_address || Address.new)]}
  end

  def self.with_no_addresses
    where('perm_address_id IS NULL && temp_address_id IS NULL')
  end

  # returns an ActiveRecord::Relation object
  # representing a database search for matches against
  # address (temp or perm) and clients
  def self.matching_fields(type, household_search)
    a = select(['households.id', :"#{type}_address_id"])
    b = matching_address(type, household_search) if household_search.has_address_params?
    c = matching_clients(household_search) if household_search.has_client_params?
    [a,b,c].compact.inject{|x,y| x.merge y} # here compact means tables are searched only if parameters are provided
  end

  # returns an ActiveRecord::Relation object, or nil if no relevant parameters are provided
  # representing database search for matching addresses
  def self.matching_address(type, household_search)
    table = "#{type}_address" # e.g. "perm_address"
    a = includes(:"#{table}")
    b = table.camelize.constantize.matching(household_search.params) # e.g. PermAddress
    a.merge b
  end

  # returns an ActiveRecord::Relation object, or nil if no relevant parameters are provided
  def self.matching_clients(household_search)
    includes(:clients).where("clients.lastName LIKE ?", "%#{ household_search.client_name }%")
  end

  def self.matching(household_search)
    unless household_search.blank?
      households = with_address_matching(:perm, household_search).each{|h| h.map_address_from(:perm_address)}
      households += with_address_matching(:temp, household_search).each{|h| h.map_address_from(:temp_address)}
      households.uniq
    end
  end

  validate do |household|
    errors.add(:base, "A household must have either a permanent or a temporary address") unless household.has_full_perm_or_temp_address?
  end

  # overwrite the ActiveModel method here and define the humanized attributes
  # in the model rather than in a locales file
  def self.human_attribute_name(attr, options = {})
    HumanizedAttributes[attr.to_sym] || super
  end

  # override the column attribute as it's often incorrect!
  def resident_count
    clients.count
  end

  def has_head?
    head_count > 0
  end

  def has_no_head?
    head_count == 0
  end

  def has_single_head?
    head_count == 1
  end

  # it's an error condition!
  def has_multiple_heads?
    head_count > 1
  end

  def distribution_color_code
    DistributionColorCodes[[6,resident_count].min]
  end

  # returns true if either all perm address fields or all temp address fields are present
  def has_full_perm_or_temp_address?
    [(perm_address && perm_address.complete?), (temp_address && temp_address.complete?)].any?
  end

  # configures the parameter that controls delegation to either temp address or perm address
  # depending on which matched the search criteria
  def map_address_from(temp_or_perm)
    @matching_address = temp_or_perm
  end

  # methods are delegated either to perm_address or temp_address dynamically
  # depending on the value of @matching address
  [:address, :city, :zip, :has_po_box?, :has_po_box, :po_box_number, :street_name, :street_number].each do |attr| 
    define_method(attr) do
      if @matching_address && (add = self.send(@matching_address))
        add.send(attr)
      end
    end
  end

  def client_names
    clients.map(&:lastName).uniq.compact.sort.join(', ')
  end

  # returns information about any and all expired documentation for the
  # household and its clients. Used during client check in.
  def qualification
     [res_qualification_vector,
      inc_qualification_vector,
      gov_qualification_vector]
  end

  def client_docs
    clients.sort_by(&:age_or_zero).map(&:id_qualification_vector).compact
  end

  def qualification_docs
    qualification + client_docs
  end

  def with_errors
    has_client_errors? || has_household_errors?
  end

  def has_client_errors?
    !clients.map(&:id_current?).all?
  end

  def has_household_errors?
    ![res_current?, inc_current?, gov_current?].all?
  end

  def has_res_doc_in_db?
    res_qualdoc && res_qualdoc.in_db?
  end

  def has_inc_doc_in_db?
    inc_qualdoc && inc_qualdoc.in_db?
  end

  def has_gov_doc_in_db?
    gov_qualdoc && gov_qualdoc.in_db?
  end

  def res_doc_exists?
    res_qualdoc &&
      res_qualdoc.docfile &&
      res_qualdoc.docfile.current_path &&
      File.exists?(res_qualdoc.docfile.current_path)
  end

  def inc_doc_exists?
    inc_qualdoc &&
      inc_qualdoc.docfile &&
      inc_qualdoc.docfile.current_path &&
      File.exists?(inc_qualdoc.docfile.current_path)
  end

  def gov_doc_exists?
    gov_qualdoc &&
      gov_qualdoc.docfile &&
      gov_qualdoc.docfile.current_path &&
      File.exists?(gov_qualdoc.docfile.current_path)
  end

  def count_by_homeless
    value = homeless? ? 1 : 0
    {:homeless => value}
  end

  def new_or_continued_in_month(year,month)
    date_of_first_distribution = distributions.sort_by(&:created_at).first.created_at
    new = (date_of_first_distribution.year == year) && (date_of_first_distribution.month == month)
    new ? :new : :continued
  end

  def new_in?(year,month)
    new_or_continued_in_month(year,month) == :new
  end

  def family_structure
    if clients.size == 1
      "one person household"
    elsif one_male_adult && child_count > 0
      "single male parent"
    elsif one_female_adult && child_count > 0
      "single female parent"
    elsif adult_count == 2 && child_count > 0
      "couple w/ children"
    elsif adult_count == 2 && child_count == 0
      "couple w/o children"
    else
      "other family structure"
    end
  end

  def one_male_adult
    adults = clients.select(&:adult)
    adult_males = adults.select(&:male)
    (adult_count == 1) && (adult_males.length == 1)
  end

  def one_female_adult
    adults = clients.select(&:adult)
    adult_females = adults.select(&:female)
    (adult_count == 1) && (adult_females.length == 1)
  end

  def adult_count
    clients.select(&:adult).length
  end

  def child_count
    clients.select(&:child).length
  end

private
  # to determine the error condition of multiple heads of household
  def head_count
    clients.map(&:headOfHousehold?).count(true)
  end
end
