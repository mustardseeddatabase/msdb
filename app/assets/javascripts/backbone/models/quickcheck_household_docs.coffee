class Quickcheck.HouseholdDocs extends Backbone.Collection
  model: Quickcheck.HouseholdDoc

  quickcheck_completed: ->
    @all (model) ->
      model.quickcheck_completed()

