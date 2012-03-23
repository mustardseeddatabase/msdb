# Manages a view that is shown when an item has no barcode and the user
# will type a description fragment to pull items with matching descriptions
# from the database.
# The view is shown while the typing and selection is being done, and when
# the selection is made, the view is removed and replaced by the selected
# item.
class Application.SkuSelectorView extends Backbone.View
  el: '#found_in_db'

  initialize : (args) ->
    @application = args.application
    @autocomplete_include = args.include
    @item = new Application.Item()
    @template   =  JST["backbone/templates/sku_template"]
    @item.bind('change', @update, @)
    _.bindAll(@, "render")
    @render()

  events: {
    "click #remove_transaction_item_link" : "remove"
  }

  remove: ->
    $('#description_autocomplete').remove()

  # can't render the view while autocompleter is active, so just update individual fields
  # this scenario is where item fields are updating as user moves focus up/down the 
  # autcomplete results list
  update: ->
    $('#description_autocomplete td#sku',            @el).text(         @item.get('sku'))
    $('#description_autocomplete input#description', @el).attr('value', @item.get('description'))
    $('#description_autocomplete td#weight_oz',      @el).text(         @item.get('weight_oz'))
    $('#description_autocomplete td#count',          @el).text(         @item.get('count'))
    $('#description_autocomplete td#category',       @el).text(categories.get(@item.get('category_id')).get('descriptor'))
    $('#description_autocomplete td#qoh',            @el).text(         @item.get('qoh'))

  configure_autocomplete: ($el, context) ->
    $('input#description',$el).autocomplete
      url           : '/items/autocomplete'
      minChars      : 3
      paramName     : 'description'
      onItemSelect  : (item) -> context.select_item(item)
      onItemFocus   : (item) -> context.show_item_details(item) # as focus moves up/down the result list, populate the view with details other than description
      showResult    : (value, data) -> " data-object='"+_(data).escape()+"'>"+value # autocompleter internal callback used to incorporate item attributes into results list
      filterResults : true
      alwaysInclude : @autocomplete_include
      sortResults   : false

  # when user selects one of the autocompleter results
  select_item: ->
    $('#description_autocomplete').remove()
    @application.add_selected_item(@item)

  # when user hovers over one of the autocompleter results
  show_item_details: (autocompleter_item) ->
    # item data is stashed as JSON in html5 data-object in the autocompleter list tags
    new_item_attributes = $(autocompleter_item).data('object')
    @item.set(new_item_attributes)

  render: ->
    $('#headings').after(@template({barcode: '', item: @item}))
    @configure_autocomplete($(@el), @)
    @
