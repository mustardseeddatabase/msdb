#= require backbone/views/quickcheck_doc_view
class Quickcheck.ClientView extends Quickcheck.DocView
  tagName: 'tr'

  className: 'client'

  initialize: ->
    @template = JST["backbone/templates/client_doc"]
    @model.bind('change',@update,@)

  render: ->
    $(@el).append @template(client : @model)
