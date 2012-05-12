class Item < ActiveRecord::Base

  has_many :distribution_items, :dependent => :destroy
  has_many :distributions, :through => :distribution_items, :dependent => :destroy
  has_many :donated_items, :dependent => :destroy
  has_many :donations, :through => :donated_items, :dependent => :destroy
  belongs_to :category
  attr_accessor :cid

  scope :with_sku, where('sku IS NOT NULL')
  scope :with_upc, where('upc IS NOT NULL')
  scope :with_description, lambda{|description| where("description like ?", "%#{description}%").order(:description)}
  scope :excluding, lambda { |ids| where("id NOT IN (?)", ids) }
  scope :preferred, where('preferred = ?', true)

  AttributeErrorMessages = {
      :description       => "Invalid description",
      :weight_oz         => "Weight can't be blank or zero",
      :count             => "Count can't be blank or zero",
      :quantity          => "Quantity can't be blank or zero",
      :category_id       => "Please select a category"
  }

  def self.attribute_error_messages
    AttributeErrorMessages.to_json
  end

  class DescriptionFormatValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "cannot be only numbers" unless value =~ /^\D+$/
    end
  end

  validates :category_id, :count, :presence => true
  validates :count, :weight_oz, :presence => true, :numericality => {:greater_than => 0}
  validates :description, :presence => true, :description_format => true
  validates :upc, :sku, :uniqueness => true, :allow_nil => true, :on => :create # because sku and upc are not editable, so it's a bit quicker to skip this validation on update
  validate do |item| # may be superfluous, as sku is automatically added if !has_identifier is false
    errors.add(:base, "Either SKU or UPC must be present") unless item.has_identifier?
  end

  # if an item is being created without a barcode or sku, assign the next sku
  before_validation do
    unless has_identifier?
      self.sku = Item.maximum(:sku).to_i.next
    end
  end

  def self.match_to_inventory(inventory)
    Item.excluding(inventory.item_ids).update_all(:qoh => 0)
    inventory.inventory_items.each do |inventory_item|
      Item.find(inventory_item.item_id).update_attribute(:qoh,inventory_item.quantity)
    end
  end

  def self.find_with_attributes(attrs)
    return where("id = ?",attrs[:id]).first if attrs[:id]
    return where("upc = ?",attrs[:upc]).first if attrs[:upc]
    return where("sku = ?",attrs[:sku]).first if attrs[:sku]
  end

  def has_identifier?
    [sku, upc].any?
  end

  def source
    'server'
  end

  def category_name
    category.try(:name)
  end

  def limit_category_id
    category.try(:limit_category_id)
  end

  def category_descriptor
    category.try(:descriptor)
  end

  def escaped_description
    description.gsub(/"/,"&#34;").gsub(/'/,"&#39;") # escape single/double quotes
  end

  def for_autocompleter
    self.count = 1 if count == 0 # this is a convenience hack to avoid the user constantly having to fix zero-count items
    details = self.to_json(:methods => [:source, :category_descriptor, :category_name, :limit_category_id], :except => [:created_at, :updated_at])
    [description,"(",weight_oz," oz)", "|", details].join
  end

  def cid_map
    {:id => id, :cid => cid}
  end

end
