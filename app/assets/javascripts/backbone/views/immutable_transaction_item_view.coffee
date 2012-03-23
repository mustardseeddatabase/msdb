#= require ./transaction_item_view
class Application.ImmutableTransactionItemView extends Application.TransactionItemView

  initialize: ->
    _.bindAll(@, 'render', 'remove')
    @template = JST["backbone/templates/transaction_item_no_edit"] # a template with no editable fields, when preloading existing items for donation edit
    @model.bind('change:quantity', @render)
    @model.get('item').bind('change:category_id', @render, @)

  render: ->
    $(@el).html(@template(transaction_item: @model))
    @
