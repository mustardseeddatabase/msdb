class Application.ItemStatusView extends Backbone.View
  el : '#found_in_db'

  initialize: (args) ->
    @template = JST["backbone/templates/item_status"]
    @edit_template = JST["backbone/templates/item_edit"]
    # select is triggered when one of the autocompleter result set is selected
    @model.bind('select', @render, @)
    @model.bind('change', @update_error_highlights, @)

  update_error_highlights: ->
    _(['description', 'weight_oz', 'count', 'category_id']).each( (attribute) =>
      if(@model.has_errors_on(attribute))
        @highlight_error_field(attribute)
      else
        @remove_error_highlight(attribute)
    )

  highlight_error_field: (errored_attribute) ->
    $('#'+errored_attribute ,@el).addClass('configuration_error')

  remove_error_highlight: (errored_attribute) ->
    $(".configuration_error, ##{errored_attribute}", @el).removeClass('configuration_error')

  events:
    "click #edit_item_link"     : "render_for_edit"
    "click #update_item"        : "save_item"
    "keyup input#description"   : "update_item"
    "keyup input#weight_oz"     : "update_item"
    "keyup input#count"         : "update_item"
    "change select#category_id" : "update_item"
    "keyup input#qoh"           : "update_item"

  update_item: (event) ->
    @model.update(event)

  save_item: ->
    @model.save(@model.attributes,
      success: @render_flash_message)

  render_flash_message : (model, response)->
    msg = new Application.FlashMessageView
    msg.render(response)

  render_for_edit: ->
    @_remove_previous() # because only one item at a time is rendered
    $("#found_in_db").append(@edit_template(barcode : @model.identifier(), item : @model))

  render: ->
    @_remove_previous() # because only one item at a time is rendered
    $("#found_in_db").append(@template(item : @model))

  _remove_previous: ->
    if $("#found_in_db tr").length > 1
      $("#found_in_db tr:last").remove()
