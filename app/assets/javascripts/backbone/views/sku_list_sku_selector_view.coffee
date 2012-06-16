#= require '../views/sku_selector_status_view'
# Alternative rendering of the parent class (different template and el) for selecting items for the preferred sku list
class Application.SkuListSkuSelectorView extends Application.SkuSelectorStatusView
  el: "#container"

  initialize: (args)->
    @template = JST["backbone/templates/preferred_sku_template"]
    @application = args.application
    @item = new Application.Item()
    @item.bind('change', @render, @)
    _.bindAll(@, "render")
    @configure_autocomplete($(@el), @)
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

  select_item: ->
    @render()
    $('#add_to_list').removeAttr('disabled') # enables the "Add to list" button

  update: ->
    category_id = @item.get('category_id')
    if category_id
      descriptor = categories.get(category_id).get('descriptor')
    $('#description_autocomplete td#sku',            @el).text(         @item.get('sku'))
    $('#description_autocomplete input#description', @el).attr('value', @item.get('description'))
    $('#description_autocomplete td#weight_oz',      @el).text(         @item.get('weight_oz') || "")
    $('#description_autocomplete td#count',          @el).text(         @item.get('count') || "")
    $('#description_autocomplete td#category',       @el).text(descriptor || "")
    $('#description_autocomplete td#qoh',            @el).text(         @item.get('qoh'))

