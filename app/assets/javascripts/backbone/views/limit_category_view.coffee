# the individual limit category view within the table
# includes both the current count, the threshold value
# and a graphical bar representation of the current count
# with color-coding of count/threshold comparison
class Application.LimitCategoryView extends Backbone.View
  tagName: 'td'

  initialize: (args)->
    @name = args.name
    @sanitized_name = @name.replace(/[^a-z,A-Z]+/g,'')
    @value = if (args.value == undefined) || (_(args.value).isNaN())
               0
             else
               args.value

    @template = JST["backbone/templates/limit_category"]

    @category_threshold = parseInt(category_thresholds[@name]) # category_thresholds is a global array populated by the server

    @threshold_class = if(@value == @category_threshold)
      'at_threshold'
    else if (@value > @category_threshold)
      'over_threshold'
    else if (@value < @category_threshold)
      'below_threshold'

    _.bindAll(@, 'render')

  render : ->
    span_id = @sanitized_name + "_quantity"
    width = parseInt(@value,10) * 10
    @template
      name : @name,
      span_id : span_id,
      value : @value,
      category_threshold : @category_threshold,
      sanitized_name : @sanitized_name,
      threshold_class : @threshold_class,
      width : width
