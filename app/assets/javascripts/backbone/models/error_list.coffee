# manages almost all errors
# immediate errors may be added when a barcode is scanned
# or the save button is clicked
# also contains errors relating to the most recent scanned item
# immediate errors are reset (cleared and set again) when a barcode
# is scanned or save button clicked
# view is rendered for all initiating events (scan, save:click, item change, transaction item change)
class Application.ErrorList extends Backbone.Model

  # initialized with the collection of transaction_items
  initialize: (args) ->
    @collection = args.collection
    @item = args.item
    @view = new Application.ErrorView()
    @collection.bind('change', @update, @) if typeof(@collection) != 'undefined'
    @item.bind('change', @update, @) if typeof(@item) != 'undefined'
    @bind('set', @view.render, @view)
    _.bindAll(@, 'errors', 'last_entry', 'messages')

  update: ->
    @clear_immediate_errors()
    @view.render()

  # errors is an array of the errors associated with the last entry
  # an error may have an associated field, and always has an associated message:
  # {field : field_name, message : "some message"}
  errors: ->
    if ((typeof(@last_entry()) != 'undefined') && @last_entry().errors())
      @immediate_errors.concat(@last_entry().errors())
    else
      @immediate_errors

  messages: ->
    _(@errors()).filter (err) ->
      err.message != undefined
    .map (err) ->
      err.message
    .join(' ')

  last_entry: ->
    if typeof(@collection) != 'undefined'
      @collection.first()
    else
      @item

  set: (attr, value) ->
    @[attr] = value
    @trigger('set')

  clear_immediate_errors: ->
    @immediate_errors = []

  # immediate errors include response to user actions, for example:
  # "no items to save" if the user hits save when no items have been
  # scanned. They have just a message, no field.
  immediate_errors: [],

  is_empty: ->
    @errors().length == 0
