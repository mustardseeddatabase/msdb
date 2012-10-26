@Quickcheck = {}
class Quickcheck.QualdocView extends Backbone.View
  el: '#quickcheck'

  events:
    "click #quickcheck_completed" : "quickcheck_completed"
    "click .edit_client"          : "post"

  post: (event)->
    url = $(event.target).data('url')
    tmpForm = document.createElement("form")
    tmpForm.method="post"
    tmpForm.action = url
    @add_elements_from(@docs.map((d)->d.server_attributes()),tmpForm)
    tmpInput = document.createElement("input")
    tmpInput.setAttribute("name", "authenticity_token")
    tmpInput.setAttribute("value", window.authenticity_token)
    tmpForm.appendChild(tmpInput)
    document.body.appendChild(tmpForm)
    tmpForm.submit()
    document.body.removeChild(tmpForm)

  add_elements_from: (collection, form) ->
    @create_element("primary_client_id", client_id, form)
    _(collection).each (doc)=>
      @create_element("qualification_documents[][association_id]", doc.association_id, form)
      @create_element("qualification_documents[][confirm]",        doc.confirm, form)
      @create_element("qualification_documents[][date]",           doc.date, form)
      @create_element("qualification_documents[][doctype]",        doc.doctype, form)
      @create_element("qualification_documents[][id]",             doc.id, form)
      @create_element("qualification_documents[][warned]",         doc.warned, form)
      @create_element("qualification_documents[][warnings]",       doc.warnings, form)

  create_element: (name,value,form) ->
    if _.isNumber(value) || !_.isEmpty(value) || _.isBoolean(value) # because Chrome sends the value "null" for null values
      tmpInput = document.createElement("input")
      tmpInput.setAttribute("name", name)
      tmpInput.setAttribute("value", value.toString())
      form.appendChild(tmpInput)

  quickcheck_completed: ->
  #TODO move this to the collection
    ajax_parameters = 
      dataType: 'text',
      data:@docs.server_attributes(),
      url: '/clients/' + client_id + '/checkins/' + id,
      success: @show_color_code,
      error: @checkin_fail

    Backbone.sync("update", null, ajax_parameters)

  checkin_fail: (jqXHR, textStatus)->
    new Quickcheck.ErrorView(jqXHR, textStatus)

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
    else
      $('#quickcheck_completed').hide()

