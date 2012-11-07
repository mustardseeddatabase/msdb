class Quickcheck.UploadView extends Backbone.View
  initialize: ->
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
      $('#docform').attr('action',@model.upload_url)
      $('#authenticity_token').attr('value', authenticity_token)
      # TODO move this to the model
      data = [{name:"utf8", value:"&#10003"},
              {name:"authenticity_token", value:authenticity_token},
              {name:"qualification_document[association_id]", value:@model.get('association_id')},
              {name:"qualification_document[doctype]", value:@model.get('doctype')}]
      data.push {name:"_method", value:"put"} if !@model.new()
      $.ajax(@model.upload_url + @doc_id_or_new(), {
           #data: $("input",$(@el)).serializeArray(),
           data: data,
           files: $("#docfile_input"),
           iframe: true,
           processData: false,
           type: "POST"}).
           complete (data,statusText)=>
             @cancel()
             @model.set(JSON.parse(data.responseText))
             flash = new Application.FlashMessageView
             flash.render notice: ["Document saved"]
      true

  document: ->
    $('#docfile_input').val().length != 0

  render: ->
    $('body').append("<div id='scree'/>")
    $('#scree').fadeIn()
    $(@el).html(@template())
    $('body').append(@el)
    $('#upload_form_contents').fadeIn()

  doc_id_or_new: ->
    if @model.new()
      ""
    else
      "/"+@model.get('id')
