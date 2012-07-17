#= require backbone/models/quickcheck_doc
class Quickcheck.Client extends Quickcheck.Doc
  initialize: ->
    @set('warned':false)
    @view = new Quickcheck.ClientView({model:@})

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
