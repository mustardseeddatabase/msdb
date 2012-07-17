#= require backbone/models/quickcheck_doc
class Quickcheck.HouseholdDoc extends Quickcheck.Doc
  initialize: ->
    @set('warned':false)
    @view = new Quickcheck.HouseholdDocView({model:@})
