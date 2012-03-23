class Application.TransactionItemView extends Backbone.View

  tagName: 'tr'

  className: 'transaction_item'

  events: {
    "click #remove_transaction_item_link" : "remove_transaction_item"
  }

  remove_transaction_item: ->
    $(@el).unbind()
    @remove()
    @model.delete_or_mark_for_deletion()

