class Quickcheck.Docs extends Backbone.Collection

  model: Quickcheck.Doc

  clients: ->
    @select (doc)-> doc.get('doctype') == 'id'

  household_docs: ->
    @select (doc)-> doc.get('doctype') != 'id'

  quickcheck_completed: ->
    @all (model) ->
      model.quickcheck_completed()

  server_attributes: ->
    $.param( {qualification_documents : @models.map (model)->model.server_attributes()} )
