alert("anyone home?")
class Application.Barcode extends Backbone.Model
  initialize : ->
    @bind("change:barcode_value", -> @do_validate @)
    @set({error_message : ""}, {silent : true})

  do_validate : ->
    if(@valid())
      @set(error_message : "")
      @trigger("valid_barcode")
    else
      @set(error_message : "Invalid barcode")

    @reset_value() # once the input value is validated, discard it

  valid: ->
    barcode = @get('barcode_value')
    letters = barcode.match(/\D+/)
    nil     = (barcode.length == 0)
    !letters && !nil

  reset_value: ->
    @set({barcode_value : ""}, {silent : true})
