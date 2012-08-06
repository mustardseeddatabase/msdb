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
