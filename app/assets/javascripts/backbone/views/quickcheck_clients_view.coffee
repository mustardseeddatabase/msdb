class Quickcheck.ClientsView extends Backbone.View
  el: '#client_headings'

  initialize: ->
    _.bindAll(@, 'render')

  render: ->
    _(@collection).each (model) =>
      $(@el).after model.view.render()
