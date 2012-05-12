#
#   When a barcode is scanned, possible results are:
#     Item in database
#       has errors, user is alerted about the errors an next step is blocked until errors are fixed
#       has no errors
#     Item in local cache
#     Item not in database
#       user enters details and next step is blocked until all details are present
#   When no barcode is available, user enters description, possible results are:
#     Description matches an item in the database
#       it has errors
#       it has no errors
#     No matching item in the database, user enters details, next step is blocked until all details are present
#
@Application = {}
class Application.TransactionAppView extends Backbone.View
  el: '#transaction_list_app'

  events:
    "click #no_barcode"    : 'no_barcode'
    "click #submit_button" : 'save_transaction'

  no_barcode: ->
    sku_selector = new Application.SkuSelectorView(application : @, include : "New Item")

  initialize: (transaction, urlRoot, save_method)->
    # a transaction is either a distribution, a donation, or an inventory
    @save_method = save_method
    @transaction = new Application.Transaction({transaction : transaction, application : @, urlRoot : urlRoot})
    barcode_input = new Application.BarcodeInputView({ application: @}); # the barcode input and related scan errors
    @transaction_items_view = new Application.TransactionItemsView({collection : @transaction.transaction_items})
    @transaction_items_view.render()

  blocked_by_incomplete_entry: ->
    @transaction.last_transaction_item_has_errors()

  # a new barcode is not accepted until previous errors have been corrected
  handle_barcode: (barcode)->
    if !@blocked_by_incomplete_entry()
      errorlist.clear_immediate_errors()
      @transaction.get_description(barcode)

  add_selected_item: (item)->
    # transaction_items could be distribution_items or a donation_items
    # or an inventory_item
    # depending on where this view was created
    @transaction.transaction_items.add({ quantity : 1, item : item})

  save_transaction: ->
    @transaction.save(@save_method)
