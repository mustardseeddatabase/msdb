class Quickcheck.CompleteView extends Backbone.View
  el: '#quickcheck'

  initialize: (@color_code, status)->
    if status == 'success'
      @template = JST['backbone/templates/quickcheck_complete']
    else
      @template = JST['backbone/templates/quickcheck_fail']

    @render()

  render: ->
    $(@el).html(@template())
