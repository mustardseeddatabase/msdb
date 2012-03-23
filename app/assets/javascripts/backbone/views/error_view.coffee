class Application.ErrorView extends Backbone.View

  el: '#error_message',

  render: ->
    messages = errorlist.messages() || ""
    $(@el).text(messages)
