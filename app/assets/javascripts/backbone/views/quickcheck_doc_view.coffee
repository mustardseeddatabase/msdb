class Quickcheck.DocView extends Backbone.View
  events:
    "click .warn"          : "warn"
    "click .confirm"       : "confirm"
    "click .upload"        : "upload"

  upload: (event)->
    new Quickcheck.UploadView()

  confirm: (event)->
    event.preventDefault()
    @model.confirm()

  warn: (event)->
    event.preventDefault()
    if @model.get('status') != 'current'
      @model.set('warned':!@model.get('warned'))
      if @model.get('warned')
        @model.increment_warnings()
        $('.warn', @el).text('Unwarn')
      else
        @model.decrement_warnings()
        $('.warn', @el).text('Warn')

  update: ->
    $('.count',@el).text(@model.get('warnings'))
    if @model.get('date') != null
      $('.date',@el).text(@model.get('date'))
    $('.status',@el).text(@model.get('status'))
    if @model.get('status') == 'current'
      $('.status_icon',@el).removeClass('errors')
      $('.status_icon',@el).removeClass('warn_icon')
    else if @model.get('warned')
      $('.status_icon',@el).removeClass('errors')
      $('.status_icon',@el).addClass('warn_icon')
    else
      $('.status_icon',@el).addClass('errors')
      $('.status_icon',@el).removeClass('warn_icon')

