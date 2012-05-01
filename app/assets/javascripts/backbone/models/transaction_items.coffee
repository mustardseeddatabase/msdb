class Application.TransactionItems extends Backbone.Collection
    model: Application.TransactionItem

    initialize: (models) ->
      @view = new Application.TransactionItemsView({collection: @})
      @item_cache = new Application.Items()

    # get_description is invoked from the BarcodeView if a valid barcode is detected
    # if the barcode is the same as the last one, just update its quantity
    # otherwise create a new one, pulling the item from the cache
    # (cache will fetch from server if the item is not present)
    get_description : (barcode) ->
      @terminate_editing()
      if ((@models.length != 0) && (@first().get('item').get('upc') == parseInt(barcode,10))) # if the previous item has the same barcode, update it
        quantity = @first().get('quantity')
        @first().set({quantity : quantity + 1})
      else # create a new distribution item
        # use deferred object since item_cache may need to fetch description from server
        @item_cache.get_description(barcode).then (=>
          item = @item_cache.with_barcode(barcode)
          @add({item: item, quantity: 1, collection: @})
        )

    group_by_limit_category: ->
      @groupBy((di) ->
        di.get('item').get('limit_category_id')
      )

    # returns an array of category_id's and the associated quantities
    limit_counts: ->
      limcat = _(@group_by_limit_category())
      result = {}
      _(limcat.keys()).each((k) =>
        result[k] = _(@group_by_limit_category()[k]).reduce((memo,obj) ->
          memo + obj.get('quantity')
        , 0
        ) #/reduce
      ) #/each
      result

    terminate_editing: ->
      @each( (model) ->  model.terminate_editing())

    # sort so that most recent scanned items are a the top of the list
    comparator: (transaction_item) ->
        -parseInt(transaction_item.cid.slice(1),10)

    # after a collection of transaction items has been saved to the server
    # the deleted ones still remain at the client, so must delete them
    remove_deleted : ->
      @each (model) =>
        if model.get('_destroy')
          @remove(model)

    last_transaction_item_has_errors : ->
      (@length > 0) && !@first().is_fully_configured()

    toJSON: ->
      @map (ti)->
        ti.toJSON()

    set_ids: (response) ->
      @each (transaction_item) ->
        transaction_item.set_id(response)
