class Quickcheck.UploadView extends Backbone.View
  initialize: (@doc_id)->
    @template = JST["backbone/templates/upload_form"]
    @render()

  events:
    "click #cancel_upload" : "cancel"
    "click #upload_file"   : "upload"
    "change #docfile_input": "handle_file_select"

  handle_file_select: ->
    if @document()
      $('#file_message').hide()

  cancel: (event)->
    $('#scree').remove()
    @undelegateEvents()
    @remove()

  upload: ->
    if !@document()
      $('#file_message').show()
      false
    else
      true
    $('#docform').attr('action',@model.url)
    $('#docform').submit()

  document: ->
    $('#docfile_input').val().length != 0

  render: ->
    $('body').append("<div id='scree'/>")
    $('#scree').fadeIn()
    $(@el).html(@template())
    $('body').append(@el)
    $('#upload_form_contents').fadeIn()

  doc_id_or_new: ->
    if @doc_id != null
      @doc_id
    else
      'new'
