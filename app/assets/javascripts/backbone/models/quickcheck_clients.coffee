class Quickcheck.Clients extends Backbone.Collection
  model: Quickcheck.Client

  quickcheck_completed: ->
    @all (model) ->
      model.quickcheck_completed()

