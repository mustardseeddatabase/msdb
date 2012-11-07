class Quickcheck.DocView extends Backbone.View
  events:
    "click .warn"                   : "warn"
    "click .confirm"                : "confirm"
    "click .upload"                 : "upload"
    "click .delete_document_exists" : "delete"

  delete: (event)->
    if confirm 'Are you sure?'
      @_create_document_delete_form()
      @_submit_document_delete_form()
      @_remove_document_delete_form()

  upload: (event)->
    new Quickcheck.UploadView(model:@model)

  confirm: (event)->
    event.preventDefault()
    @model.confirm()

  warn: (event)->
    event.preventDefault()
    @model.warn()

  _create_document_delete_form: ->
    @delete_form = new Quickcheck.TmpFormView({action:'/checkins/'+id+'/qualification_documents/' + @model.get('id'), 'data-remote':true, 'rel':'nofollow', method:'post'},
                                              {authenticity_token: authenticity_token, _method:'delete'})

  _submit_document_delete_form: ->
    @delete_form.submit()

  _remove_document_delete_form: ->
    @delete_form.remove()
