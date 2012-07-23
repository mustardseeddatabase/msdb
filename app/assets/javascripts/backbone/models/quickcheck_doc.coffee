class Quickcheck.Doc extends Backbone.Model
  increment_warnings: ->
    current = @get('warnings') || 0
    @set('warnings':current+1)

  decrement_warnings: ->
    if current = @get('warnings') > 0
      @set('warnings':@get('warnings')-1)

  confirm: ->
    dd = new Date()
    @set('confirm':true, 'date':[dd.getFullYear(),dd.getMonth(),dd.getDate()].join('-'), 'status':'current')

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
