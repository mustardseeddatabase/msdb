class Application.ItemAppView extends Backbone.View
  el: '#transaction_list_app'

  events:
    "click #no_barcode"   : 'no_barcode'

  no_barcode: ->
    new Application.SkuSelectorStatusView(application : @)

  initialize: ->
    new Application.BarcodeInputView({ application: @}); # the barcode input and related scan errors

  handle_barcode: (barcode)->
    @item = new Application.Item({upc : barcode})
    window.errorlist = new Application.ErrorList({item : @item})
    @item.deferred.then =>
      if @item_view
        $(@item_view.el).unbind() # see http://stackoverflow.com/questions/7567404/backbone-js-repopulate-or-recreate-the-view/7607853#7607853
      @item_view = new Application.ItemStatusView(model : @item)
      @item_view.render()

  show_status: (item) ->
    item = item.item # the item returned by the autocompleter is actually a transaction item
    @item.set(item.attributes)
    @item_view.render()
