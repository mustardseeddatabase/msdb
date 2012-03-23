module AssociatedItem

  module InstanceMethods

    # if an id is supplied, update the item
    # else if a barcode is supplied, create a new item with the barcode
    # else (no id, no barcode) create item (sku assigned in a before_validation callback)
    def item_attributes=(attrs)
      # TODO handle exceptions arising from validation fail
      id = attrs.delete('id') # id present... update the item
      if id.present?
        self.item = Item.find(id)
        item.update_attributes(attrs)
      else
        self.item = Item.create(attrs)
      end
    end

  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end
