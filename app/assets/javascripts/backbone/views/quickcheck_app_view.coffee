@Quickcheck = {}
class Quickcheck.QualdocView extends Backbone.View
  el: '#quickcheck'

  initialize: (clients)->
    @clients = new Quickcheck.Clients(clients)
    @clients_view = new Quickcheck.ClientsView({collection:@clients})
    @clients_view.render()
    @household_docs = new Quickcheck.HouseholdDocs(household_docs)
    @household_docs_view = new Quickcheck.HouseholdDocsView({collection:@household_docs})
    @household_docs_view.render()
