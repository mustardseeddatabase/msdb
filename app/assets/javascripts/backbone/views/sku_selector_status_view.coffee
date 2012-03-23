#= require '../views/sku_selector_view'
# the autocomplete selector input and the selected result are rendered
# as a single item rather than a member of a list
class Application.SkuSelectorStatusView extends Application.SkuSelectorView
  # whereas the parent class adds the selected item to a collection when selected
  # this class creates a view and triggers a select event to trigger its rendering
  select_item: ->
    if @application.item_view
      $(@application.item_view.el).unbind() # see http://stackoverflow.com/questions/7567404/backbone-js-repopulate-or-recreate-the-view/7607853#7607853
    @item_view = new Application.ItemStatusView(model : @item)
    @item.trigger('select')

  render: ->
    @_remove_previous()
    $("#found_in_db").append(@template({barcode : '' , item : @item}))
    @configure_autocomplete($(@el), @)
    @

  _remove_previous: ->
    if $("#found_in_db tr").length > 1
      $("#found_in_db tr:last").remove()
