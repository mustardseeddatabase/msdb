#= require backbone/views/quickcheck_doc_view
class Quickcheck.HouseholdDocView extends Quickcheck.DocView
  tagName: 'tr'

  className: 'household_doc'

  initialize: ->
    @template = JST["backbone/templates/household_doc"]
    @model.bind('change',@render,@)

  render: ->
    $(@el).html @template(household_doc : @model)
