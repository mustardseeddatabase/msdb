class Application.TransactionItemsView extends Backbone.View
  el: '#found_in_db',

  initialize: (args) ->
    @collection.bind('add', @render, @)
    @collection.bind('reset', @render, @)
    @collection.bind('remove', @render, @)
    @template = JST["backbone/templates/item_list_headings"]
    _.bindAll(@, "render")

  render: ->
    $(@el).html(@template)
    @collection.each((transaction_item) =>
      if transaction_item == @collection.at(0)
        view = new Application.MutableTransactionItemView
          model      : transaction_item
          collection : @collection
      else
        view = new Application.ImmutableTransactionItemView
          model      : transaction_item
          collection : @collection
      $(@el).append(view.render().el) unless transaction_item.get('_destroy')
    )
    @
