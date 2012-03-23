#= require ./transaction_item_view
class Application.MutableTransactionItemView extends Application.TransactionItemView

  events: {
    "keyup input#quantity"                : "update_quantity"
    "keyup input#description"             : "update_item"
    "keyup input#weight_oz"               : "update_item"
    "keyup input#count"                   : "update_item"
    "change select#category_id"           : "update_item"
    "click #edit_transaction_item_link"   : "edit"
    "click #remove_transaction_item_link" : "remove_transaction_item"
  }

  update_item: (event) ->
    @model.get('item').update(event)
    @model.trigger('error_change')

  edit: ->
    @model.set( edit : true )

  update_quantity: (event) ->
    field_value = $('input#quantity').val()
    if(!isNaN(field_value))
      new_value = parseInt(field_value,10); # save numbers as numbers
    else
      new_value = field_value; # save text as text and let model validation make appropriate response
    @model.set({quantity : new_value}, {silent : true})
    @model.trigger('error_change')

  initialize: ->
    _.bindAll(@, 'render', 'update_error_highlights', 'remove')
    @template       = JST["backbone/templates/transaction_item"]
    @blank_template = JST["backbone/templates/new_item"] # when entering an item that is not in db, or IS in db but needs configuration errors fixed
    @item_preload_template = JST["backbone/templates/transaction_item_no_edit"] # a template with no editable fields, when preloading existing items for donation edit
    @model.bind('change:quantity', @render)
    @model.bind('change:edit', @render)
    @model.bind("error_change", @update_error_highlights, @)
    @model.get('item').bind('change:category_id', @render, @)

  render: ->
    if ( @requires_edit() ) # item in the database has errors
      identifier = @model.item_identifier()
      $(@el).html(@blank_template(transaction_item : @model, barcode: identifier, item: @model.get('item')))
    else if !@model.isNew()
      $(@el).html(@item_preload_template(transaction_item: @model))
    else # the "happy path", the item is found in the database by its barcode
      $(@el).html(@template(transaction_item: @model))
    @

  requires_edit: ->
    last_scanned = (_(@model.collection.toArray()).indexOf(@model) == 0)
    has_errors = !@model.get('item').is_fully_configured()
    user_edit = @model.get('edit')
    (last_scanned && has_errors) || user_edit

  update_error_highlights: ->
    # apply highlights for errors related to item
    _(['description', 'weight_oz', 'count', 'category_id']).each( (attribute) =>
      if(@model.get('item').has_errors_on(attribute))
        @highlight_error_field(attribute)
      else
        @remove_error_highlight(attribute)
    )
    # apply highlights for errors related to transaction_item
    if(@model.has_errors_on('quantity'))
      @highlight_error_field('quantity')
    else
      @remove_error_highlight('quantity')

  highlight_error_field: (errored_attribute) ->
    $('#'+errored_attribute ,@el).addClass('configuration_error')

  # remove highlights for all matching elements
  remove_error_highlights: ->
    $('.configuration_error', @el).removeClass('configuration_error')

  remove_error_highlight: (errored_attribute) ->
    $(".configuration_error##{errored_attribute}", @el).removeClass('configuration_error')
