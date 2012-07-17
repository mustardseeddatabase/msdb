class Quickcheck.Doc extends Backbone.Model
  increment_warnings: ->
    @set('warnings':@get('warnings')+1)

  decrement_warnings: ->
    @set('warnings':@get('warnings')-1)

  confirm: ->
    dd = new Date()
    @set('confirm':true, 'date':[dd.getFullYear(),dd.getMonth(),dd.getDate()].join('-'), 'status':'current')

  doc_error: ->
    if @get('status') == 'current'
      ''
    else
      'errors'

