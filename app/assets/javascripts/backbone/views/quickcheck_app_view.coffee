@Quickcheck = {}
class Quickcheck.QualdocView extends Backbone.View
  el: '#quickcheck'

  events:
    "click #quickcheck_completed" : "quickcheck_completed"

  quickcheck_completed: ->
  #TODO move this to the collection
    ajax_parameters = 
      dataType: 'text',
      data:@docs.server_attributes(),
      url: '/clients/' + client_id + '/qualification_documents',
      complete: @show_color_code,

    Backbone.sync("update", null, ajax_parameters)

  show_color_code: (jqXHR, textStatus)->
    new Quickcheck.CompleteView(@color_code, textStatus)

  initialize: (docs, @color_code)->
    @docs = new Quickcheck.Docs(docs)
    @docs.bind('change', @check_errors)
    @clients_view = new Quickcheck.ClientsView({collection:@docs.clients()})
    @clients_view.render()
    @household_docs_view = new Quickcheck.HouseholdDocsView({collection:@docs.household_docs()})
    @household_docs_view.render()

  check_errors: =>
    if @docs.quickcheck_completed()
      $('#quickcheck_completed').show()

