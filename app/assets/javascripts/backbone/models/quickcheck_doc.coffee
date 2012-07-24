class Quickcheck.Doc extends Backbone.Model
  initialize: ->
    @set('warned':false)
    if @get('doctype') == 'id'
      @view = new Quickcheck.ClientView({model:@})
    else
      @view = new Quickcheck.HouseholdDocView({model:@})

  increment_warnings: ->
    current = @get('warnings') || 0
    @set('warnings':current+1, 'silent':true)

  decrement_warnings: ->
    if current = @get('warnings') > 0
      @set('warnings':@get('warnings')-1, 'silent':true)

  confirm: ->
    dd = new Date()
    if @warned()
      @warn()
    @set
      'confirm':true,
      'date':[dd.getFullYear(),dd.getMonth(),dd.getDate()].join('-'),
      'status':'current'

  doc_error: ->
    if @current()
      ''
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
