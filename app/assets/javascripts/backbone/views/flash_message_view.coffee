class Application.FlashMessageView extends Backbone.View
  el : '.message_block'

  # takes a hash in the form:
  # {warn : ['a warning msg','another warning msg'], notice : [msg], etc}
  # where keys can be warn, notice, error, confirm, info
  render : (errors)->
    for error_type, error_messages of errors
      $(@el).append("<ul class=#{error_type}/>")
      _(error_messages).each (message)->
          $(".#{error_type}").append("<li>#{message}</li>")
      $(".#{error_type}").delay(1000).fadeOut(2000, -> $(@).remove())
