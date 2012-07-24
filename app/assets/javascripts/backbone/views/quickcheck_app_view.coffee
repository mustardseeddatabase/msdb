@Quickcheck = {}
class Quickcheck.QualdocView extends Backbone.View
  el: '#quickcheck'

  events:
    "click #quickcheck_completed" : "quickcheck_completed"

  quickcheck_completed: ->
    Backbone.sync("update", @docs)

  initialize: (docs)->
    @docs = new Quickcheck.Docs(docs)
    @docs.bind('change', @check_errors)
    @clients_view = new Quickcheck.ClientsView({collection:@docs.clients()})
    @clients_view.render()
    @household_docs_view = new Quickcheck.HouseholdDocsView({collection:@docs.household_docs()})
    @household_docs_view.render()

  check_errors: =>
    if @docs.quickcheck_completed()
      $('#quickcheck_completed').show()

