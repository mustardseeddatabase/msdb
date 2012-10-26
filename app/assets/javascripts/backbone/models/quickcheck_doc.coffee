class Quickcheck.Doc extends Backbone.Model
  initialize: ->
    if @get('doctype') == 'id'
      @view = new Quickcheck.ClientView({model:@})
    else
      @view = new Quickcheck.HouseholdDocView({model:@})
    @upload_url = "/clients/" + client_id + "/qualification_documents/" + @id + "/upload"
    @set('edit_url', "/clients/" + client_id + "/edit")

  increment_warnings: ->
    current = @get('warnings') || 0
    @set('warnings':current+1, 'silent':true)

  decrement_warnings: ->
    if current = @get('warnings') > 0
      @set('warnings':@get('warnings')-1, 'silent':true)

  # the user is confirming that they have received hard copy of the doc
  confirm: ->
    dd = new Date()
    if @warned()
      @warn()
    @set
      'confirm':true,
      'date':[dd.getFullYear(),dd.getMonth()+1,dd.getDate()].join('-'),
      'status':'current'

  status_class: ->
    if @current()
      ''
    else if @warned()
      'warn_icon'
    else
      'errors'

  current: ->
    @get('status') == 'current'

  warned: ->
    @get('warned')

  quickcheck_completed: ->
    @current() || @warned()

  warn: ->
    if !@current() # don't do anything if the model is current
      @set('warned':!@get('warned'))
    if @warned()
      @increment_warnings()
    else
      @decrement_warnings()

  head: ->
    if (typeof(@get('head_of_household')) != 'undefined') && @get('head_of_household') == true
      'head'
    else
      ''

  errors: ->
    if (typeof(@get('errors')) != 'undefined') && @get('errors').length > 0
      'errors'
    else
      ''

  server_attributes: ->
    _(@.attributes).pick('id', 'date', 'warnings', 'warned', 'confirm', 'doctype', 'association_id')

  has_doc: ->
    if @get('doc_link')
      "document_exists"
    else
      "document_missing"
