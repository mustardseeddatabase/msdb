class Application.Transaction extends Backbone.Model
  initialize: (attrs)->
    @urlRoot = attrs.urlRoot
    @transaction_items = new Application.TransactionItems(attrs.transaction.transaction_items)
    window.errorlist = new Application.ErrorList({collection : @transaction_items})
    @set({id : attrs.transaction.id})

  save: ->
    if @transaction_items.length == 0
      @report_immediate_error("No items to save!")
    else if @uncorrected_errors()
      @report_immediate_error("Cannot save until errors are corrected")
    else
      @clear_immediate_errors()

      method = if @isNew() then "create" else "update"

      options =
        success : @remove_deleted_transaction_items
      Backbone.sync.call(@, method, @, options)

  uncorrected_errors: ->
    !errorlist.is_empty()

  report_immediate_error: (message) ->
    errorlist.set('immediate_errors',[{message : message}])

  clear_immediate_errors: ->
    errorlist.clear_immediate_errors()

  get_description: (barcode) ->
    @transaction_items.get_description(barcode)

  toJSON : =>
    id : @get('id')
    cid : @cid
    transaction_items_attributes :  @transaction_items.toJSON()

  remove_deleted_transaction_items : (response, status) =>
    @transaction_items.remove_deleted()
    @set_ids(response)
    @render_flash_message(response.flash)

  render_flash_message : (flash)->
    msg = new Application.FlashMessageView
    msg.render(flash)

  last_transaction_item_has_errors: ->
    @transaction_items.last_transaction_item_has_errors()

  set_ids: (response) ->
    @set({'id': response.transaction.id },{silent : true})
    @transaction_items.set_ids(response)
