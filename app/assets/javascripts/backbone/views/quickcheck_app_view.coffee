@Quickcheck = {}
class Quickcheck.QualdocView extends Backbone.View
  el: '#quickcheck'

  initialize: (clients)->
    @clients = new Quickcheck.Clients(clients)
    @clients.bind('change', @check_errors)
    @clients_view = new Quickcheck.ClientsView({collection:@clients})
    @clients_view.render()
    @household_docs = new Quickcheck.HouseholdDocs(household_docs)
    @household_docs.bind('change', @check_errors)
    @household_docs_view = new Quickcheck.HouseholdDocsView({collection:@household_docs})
    @household_docs_view.render()

  check_errors: =>
    if @clients.quickcheck_completed() && @household_docs.quickcheck_completed()
      $('#quickcheck_completed').show()

