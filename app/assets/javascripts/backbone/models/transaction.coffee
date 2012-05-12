class Application.Transaction extends Backbone.Model
  initialize: (attrs)->
    @urlRoot = attrs.urlRoot
    @transaction_items = new Application.TransactionItems(attrs.transaction.transaction_items)
    window.errorlist = new Application.ErrorList({collection : @transaction_items})
    @set({id : attrs.transaction.id})

  save: (save_method)->
    if @transaction_items.length == 0
      @report_immediate_error("No items to save!")
    else if @uncorrected_errors()
      @report_immediate_error("Cannot save until errors are corrected")
    else
      @clear_immediate_errors()

      if save_method == "no-ajax"
        console.log "save without ajax"
        @post()
      else
        method = if @isNew() then "create" else "update"

        options =
          success : @remove_deleted_transaction_items
        Backbone.sync.call(@, method, @, options)

  post: ->
    tmpForm = document.createElement("form")
    tmpForm.method="post"
    tmpForm.action = @urlRoot
    @add_elements_from(@.toJSON(),tmpForm)

    tmpInput = document.createElement("input")
    tmpInput.setAttribute("name", "authenticity_token")
    tmpInput.setAttribute("value", window.authenticity_token)
    tmpForm.appendChild(tmpInput)
    document.body.appendChild(tmpForm)
    tmpForm.submit()
    document.body.removeChild(tmpForm)

  add_elements_from: (obj, form) ->
    _(obj.transaction_items_attributes).each (tia)=>
      @create_element("transaction_items_attributes[][quantity]",tia.quantity, form)
      @create_element("transaction_items_attributes[][item_attributes][category_id]",tia.item_attributes.category_id, form)
      @create_element("transaction_items_attributes[][item_attributes][count]",tia.item_attributes.count, form)
      @create_element("transaction_items_attributes[][item_attributes][description]",tia.item_attributes.description, form)
      @create_element("transaction_items_attributes[][item_attributes][id]",tia.item_attributes.id, form)
      @create_element("transaction_items_attributes[][item_attributes][weight_oz]",tia.item_attributes.weight_oz, form)

  create_element: (name,value,form) ->
    tmpInput = document.createElement("input")
    tmpInput.setAttribute("name", name)
    tmpInput.setAttribute("value", value)
    form.appendChild(tmpInput)

  uncorrected_errors: ->
    !errorlist.is_empty()

  report_immediate_error: (message) ->
    errorlist.set('immediate_errors',[{message : message}])

  clear_immediate_errors: ->
    errorlist.clear_immediate_errors()

  get_description: (barcode) ->
    @transaction_items.get_description(barcode)

  toJSON : =>
    id : @get('id')
    cid : @cid
    transaction_items_attributes :  @transaction_items.toJSON()

  remove_deleted_transaction_items : (response, status) =>
    @transaction_items.remove_deleted()
    @set_ids(response)
    @render_flash_message(response.flash)

  render_flash_message : (flash)->
    msg = new Application.FlashMessageView
    msg.render(flash)

  last_transaction_item_has_errors: ->
    @transaction_items.last_transaction_item_has_errors()

  set_ids: (response) ->
    @set({'id': response.transaction.id },{silent : true})
    @transaction_items.set_ids(response)
