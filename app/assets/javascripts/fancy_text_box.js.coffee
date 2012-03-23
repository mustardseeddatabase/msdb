class @FancyTextBox
  constructor : (@callback)->
    $('.text_input').keyup (event)=>
      @show_hide_control(event)
    $('.text_clear').click (event)=>
      @clear_text_field(event)

  show_hide_control : (event)->
    table = $(event.target).closest('table')
    if event.target.value.length > 0
      $('.text_clear', table).css('display', 'inline')
    else
      $('.text_clear', table).css('display', 'none')

  clear_text_field : (event)->
    table = $(event.target).closest('table')
    $('.text_input',table).val('')
    $('.text_input',table).focus()
    $('.text_clear',table).css('display', 'none')
    if @callback
      @callback()
