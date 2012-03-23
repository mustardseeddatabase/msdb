class Application.Items extends Backbone.Collection
  model: Application.Item

  contains: (barcode) ->
    @any((item) ->  item.has_barcode(barcode))

  get_description : (barcode) ->
    if !@contains(barcode)
      dfr = $.Deferred()
      item = new Application.Item({upc : barcode})
      item.deferred.then =>
        @add(item)
        dfr.resolve()

      dfr.promise()
    else
      $.Deferred().resolve()

  with_barcode: (barcode) ->
    @detect((item) -> item.has_barcode(barcode))

