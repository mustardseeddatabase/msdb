class Quickcheck.DocView extends Backbone.View
  events:
    "click .warn"          : "warn"
    "click .confirm"       : "confirm"
    "click .upload"        : "upload"

  upload: (event)->
    new Quickcheck.UploadView(model:@model)

  confirm: (event)->
    event.preventDefault()
    @model.confirm()

  warn: (event)->
    event.preventDefault()
    @model.warn()

  update: ->
    $('.count',@el).text(@model.get('warnings'))
    if @model.get('date') != null
      $('.date',@el).text(@model.get('date'))
    $('.status',@el).text(@model.get('status'))
    $('.status_icon',@el).removeClass('errors')
    $('.status_icon',@el).removeClass('warn_icon')
    if @model.warned()
      $('.status_icon',@el).addClass('warn_icon')
      $('.warn', @el).text('Unwarn')
    else if !@model.current()
      $('.status_icon',@el).addClass('errors')
      $('.warn', @el).text('Warn')

