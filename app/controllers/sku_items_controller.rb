class SkuItemsController < ApplicationController
  # User types in a description fragment for items without a barcode
  def autocomplete
    items = Item.with_sku.with_description(params[:description]).includes(:category)
    items = items.preferred if params[:scope] == 'preferred'
    items = items.sort_by{|i| [i.description, i.weight_oz]}
    items << Item.new(:description => 'New Item')
    items = items.map(&:for_autocompleter)
    render :text => items.join("\n")
  end
end
