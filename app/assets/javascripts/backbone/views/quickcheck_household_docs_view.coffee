class Quickcheck.HouseholdDocsView extends Backbone.View
  el: '#household_headings'

  initialize: ->
    _.bindAll(@, 'render')

  render: ->
    _(@collection).each (model) =>
      $(@el).after model.view.render()
