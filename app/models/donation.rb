class Donation < ActiveRecord::Base
  has_many :donated_items, :foreign_key => :transaction_id, :dependent => :destroy
  has_many :items, :through => :donated_items, :dependent => :destroy
  belongs_to :donor

  scope :most_recent_five, order('created_at DESC').limit(5)

  accepts_nested_attributes_for :donated_items, :allow_destroy => true
  attr_accessor :cid

  def item_cid_map
    donated_items.map(&:item_cid_map)
  end

  def donated_items_cid_map
    donated_items.map(&:cid_map)
  end

  def cid_map
    {:id => id, :cid => cid}
  end
end
