class Quickcheck.ErrorView extends Backbone.View
  el: '#quickcheck'

  initialize: (jqXHR, status)->
    @template = JST['backbone/templates/quickcheck_fail']
    @render(jqXHR.responseText)

  render: (message)->
    $(@el).html(@template({message : message }))
