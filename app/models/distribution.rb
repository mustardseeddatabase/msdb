class Distribution < ActiveRecord::Base
  belongs_to :household
  has_many :distribution_items, :foreign_key => :transaction_id, :dependent => :destroy, :autosave => true
  has_many :items, :through => :distribution_items, :dependent => :destroy
  accepts_nested_attributes_for :distribution_items
  attr_accessor :cid

  def item_cid_map
    distribution_items.map(&:item_cid_map)
  end

  def distribution_items_cid_map
    distribution_items.map(&:cid_map)
  end

  def cid_map
    {:id => id, :cid => cid}
  end
end
