# Manages the element that collects the barcode
# associated with an Application.Barcode model
class Application.BarcodeInputView extends Backbone.View
  initialize: (args) ->
    @application = args['application']
    @model = new Application.Barcode
    @model.bind("valid_barcode", @handle_barcode, @)
    @model.bind("change", @render, @)

  handle_barcode: ->
    @application.handle_barcode(@model.get('barcode_value'))

  el: 'div#barcode_input'

  input_el: "input#item_barcode"

  error_el: '#barcode_message'

  render: ->
    $(@error_el).html(@model.get('error_message'))

  clear_input: ->
    $(@input_el).val('')

  events: {
    "keyup #item_barcode" : 'detect_barcode_complete'
  }

  detect_barcode_complete : (event) ->
    if (@barcode_complete(event))
      @model.set({barcode_value : @requested_barcode()})
      @clear_input()

  barcode_complete : (event) -> event.which == 13

  requested_barcode: -> $('#item_barcode').val()

  barcode_error: (message) ->
    $('#barcode_message').html(message)
