#= require '../views/sku_selector_status_view'
# Alternative rendering of the parent class (different template and el) for selecting items for the preferred sku list
class Application.SkuListSkuSelectorView extends Application.SkuSelectorStatusView
  el: "#container"

  initialize: (args)->
    @template = JST["backbone/templates/preferred_sku_template"]
    @application = args.application
    @item = new Application.Item()
    @item.bind('change', @update, @)
    _.bindAll(@, "render")
    @render()

  events:
    "click #add_to_list" : "add_to_list"

  add_to_list: ->
    tmpForm = document.createElement("form")
    tmpForm.method="post"
    tmpForm.action = "/sku_list_items"
    @add_elements_from(@item.toJSON(),tmpForm)

    tmpInput = document.createElement("input")
    tmpInput.setAttribute("name", "authenticity_token")
    tmpInput.setAttribute("value", window.authenticity_token)
    tmpForm.appendChild(tmpInput)
    document.body.appendChild(tmpForm)
    tmpForm.submit()
    document.body.removeChild(tmpForm)

  add_elements_from: (item, form) ->
    @create_element("item[id]",item.id, form)

  create_element: (name,value,form) ->
    tmpInput = document.createElement("input")
    tmpInput.setAttribute("name", name)
    tmpInput.setAttribute("value", value)
    form.appendChild(tmpInput)

  render: ->
    $('#result').html(@template({barcode : '' , item : @item}))
    @configure_autocomplete($(@el), @)
    @

  select_item: ->
    super
    $('#add_to_list').removeAttr('disabled')
