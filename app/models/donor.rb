class Donor < ActiveRecord::Base
  has_many :donations
  default_scope order('organization')

  HumanizedAttributes = { :contactName => 'Contact name',
                          :contactTitle => 'Contact title' }

  validates :organization, :presence => true
  validates :organization, :uniqueness => {:case_sensitive => false, :message => "There is already a donor organization with that name. Donor name must be unique."}

  def to_s
    organization
  end

  def self.human_attribute_name(attr, options = {})
    HumanizedAttributes[attr.to_sym] || super
  end

  def full_address
    [address, city, state, zip].reject(&:blank?).join(', ')
  end

  def self.with_no_donations
    includes(:donations).select{|d| d.donations.empty? }
  end

  def self.with_duplicate_org_names
    duplicates = all.select do |donor|
                    if donor.organization
                      all.map(&:organization).count(donor.organization) > 1
                    end
                  end
    duplicates.uniq
  end
end
