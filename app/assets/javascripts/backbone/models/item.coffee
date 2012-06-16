class Application.Item extends Backbone.Model
  initialize: (init)->
    if @get('with') # item is initialized from data loaded at page load
      @set(@get('with'))
      @unset('with',{silent : true})
    else if @get('upc')
      @deferred = $.Deferred()
      @fetch
        success : =>
          @deferred.resolve()

  update : (event) ->
    attr = $(event.currentTarget).attr('id')

    value = $(event.currentTarget).val()
    if(!isNaN(value) && (value.length > 0)) # because blank string evaluates to 0 and !isNaN("")
      value = parseInt(value,10)

    # need to set attributes directly as the attribute is selected dynamically
    @attributes[attr] = value

    if attr == 'category_id'
      @set({category_name : @category().get('name')}, {silent : true}) unless typeof(@category()) == 'undefined'
      @set({category_descriptor : @category().get('descriptor')}, {silent : true}) unless typeof(@category()) == 'undefined'
      @set({limit_category_id : @limit_category_id()}, {silent : true})

  category: ->
    categories.get(@get('category_id'))

  limit_category_id: ->
    if @category()
      @category().get('limit_category_id')

  category_descriptor: ->
    if @category()
      @category().get('descriptor')

  url : ->
    '/upc_items/' + @get('upc')

  sanitized_name: ->
    @get('name').replace(/[^a-z,A-Z]+/g,"")

  has_barcode: (barcode) ->
    @get('upc') == parseInt(barcode,10)

  is_fully_configured: ->
    (@first_configuration_error() == null)

  is_no_barcode_new_item: ->
    @get('description') == "New Item"

  first_configuration_error: ->
    fields = [ 'description', 'weight_oz', 'count', 'category_id']
    for field in fields
      if @has_errors_on(field)
        val = field
        break
    if val == undefined then null else val

  has_errors_on: (field) ->
    if(field.match(/description/))
      @invalid_text(@get(field))
    else
      @invalid_number(@get(field))

  view_class_for: (attribute) ->
    if @has_errors_on(attribute)
      "configuration_error"
    else
      ""

  invalid_number: (value) ->
    (value == null) || (value == "") || (value == 0) || (value == '0') || isNaN(value)

  invalid_text: (value) ->
    (value == null) || (value == "") || (value == 0) || (value == '0') || value.match(/^\d+$/) || value.length < 4

  error_messages: ->
    # note error_messages is a global array loaded from the server
    if(typeof(error_messages) != 'undefined')
      error_messages

  first_error_message: ->
    [{field : @first_configuration_error(), message : @error_messages()[@first_configuration_error()] }]

  errors : ->
    if (!(@is_fully_configured()))
      message = if (@get('source') == 'server')
                  [{message : "The item in the database has errors. "}]
                else
                  []
      message.concat(@first_error_message())

  toJSON: ->
    id : @get('id'),
    cid : @cid
    sku : @get('sku'),
    upc : @get('upc'),
    description : @get('description'),
    weight_oz : @get('weight_oz'),
    count : @get('count'),
    qoh : @get('qoh'),
    category_id : @get('category_id') 

  set_id: (response) ->
    ti = _(response.items).find (item)=>
      item.cid == @cid
    @set({'id': ti.id},{silent : true})

  identifier: ->
    @get('upc') || @get('sku')
