class Inventory < ActiveRecord::Base
  has_many :inventory_items, :foreign_key => :transaction_id, :dependent => :destroy, :autosave => true
  has_many :items, :through => :inventory_items, :dependent => :destroy
  accepts_nested_attributes_for :inventory_items
  attr_accessor :cid

  def item_cid_map
    inventory_items.map(&:item_cid_map)
  end

  def inventory_items_cid_map
    inventory_items.map(&:cid_map)
  end

  def cid_map
    {:id => id, :cid => cid}
  end
end
