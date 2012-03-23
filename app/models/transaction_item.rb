class TransactionItem < ActiveRecord::Base
  include AssociatedItem
  belongs_to :item

  attr_accessor :cid

  def cid_map
    {:id => id, :cid => cid}
  end

  def item_cid_map
    item.cid_map
  end
end
