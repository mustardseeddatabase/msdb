class Quickcheck.Docs extends Backbone.Collection
  url: '/qualification_documents'

  model: Quickcheck.Doc

  clients: ->
    @select (doc)-> doc.get('doctype') == 'id'

  household_docs: ->
    @select (doc)-> doc.get('doctype') != 'id'

  quickcheck_completed: ->
    @all (model) ->
      model.quickcheck_completed()

