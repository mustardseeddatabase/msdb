class Distribution < ActiveRecord::Base
  belongs_to :household
  has_many :distribution_items, :foreign_key => :transaction_id, :dependent => :destroy, :autosave => true
  has_many :items, :through => :distribution_items, :dependent => :destroy
  accepts_nested_attributes_for :distribution_items
  attr_accessor :cid

  scope :in_month, lambda{|year,month| where('(YEAR(created_at) = ?) & (MONTH(created_at) = ?)', year, month)}

  def self.demographic_for_month(date)
    households_in_month = in_month(date.year, date.month).map(&:household).uniq
    households = HouseholdCollection.new(households_in_month)
    households.report_demographics(date)
  end

  def item_cid_map
    distribution_items.map(&:item_cid_map)
  end

  def distribution_items_cid_map
    distribution_items.map(&:cid_map)
  end

  def cid_map
    {:id => id, :cid => cid}
  end

  def new?
    household.distributions.sort_by(&:created_at).index(self) == 0
  end

end
