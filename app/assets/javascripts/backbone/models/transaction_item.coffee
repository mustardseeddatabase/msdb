# a distribution item is comprised of an item, and a quantity
class Application.TransactionItem extends Backbone.Model
  initialize: (attrs)->
    # When data is supplied at page load, e.g. editing a donation
    # backbone initializes the transaction item, but assigns a js object to the item attribute
    # 1. edit donation, 'this' has js object iso instantiated item, and attrs is a js obj representing transaction item
    # 2. new item from barcode: transaction_item and item are already instantiated at this point
    # 3. existing item with barcode: ditto

    if attrs.item && !(@get('item') instanceof Backbone.Model) # e.g. when data set is supplied at page load
      @set({item : new Application.Item({with : attrs.item})})
    _(["change", "add", "remove", "error_change"]).each ( (event) =>
      # change on the collection re-evaluates the errors
      @bind(event, ->  @collection.trigger("change") )
    )
    @get('item').bind("change", => @collection.trigger('change'))

  delete_or_mark_for_deletion : ->
    if @isNew()
      @collection.remove(@)
    else
      @set({_destroy : true})

  is_fully_configured: ->
    !@has_errors_on('quantity') && @get('item').is_fully_configured()

  has_errors_on: ->
    quantity = @get('quantity')
    ((quantity == 0 ) ||(quantity == "0" ) || (quantity == "") || isNaN(quantity))

  # an array of errors of the form {field : fieldname, message : "message"}
  # where field is optional, is used to highlight the errored field
  errors: ->
    item_errors = @get('item').errors()
    if typeof(item_errors) != 'undefined'
      _.extend(@get('item').errors(), @error_message())
    else
      @error_message()

  error_message: ->
    if (!(@is_fully_configured()))
      {field : 'quantity', message : "Quantity must not be zero or blank"}

  terminate_editing: ->
    @set({ edit : false})

  toJSON: ->
    id              : @get('id')
    cid             : @cid
    item_attributes : @get('item').toJSON()
    quantity        : @get('quantity')
    _destroy        : @get('_destroy') || false

  set_id: (response) ->
    ti = _(response.transaction_items).find (transaction_item)=>
      transaction_item.cid == @cid
    @set({'id': ti.id},{silent : true})
    @get('item').set_id(response)

  item_identifier: ->
    @get('item').identifier()
