# the table that renders all the limit categories
class Application.LimitCategoriesView extends Backbone.View
  el: 'table#limit_categories'

  initialize: (options) ->
    # collection is the transaction items
    @collection = options.collection
    @collection.bind("change", @render, @)
    @render()

  render: ->
    collection = @collection.limit_counts()
    # collection, e.g. {8:1, 5:3} keys are limit category ids
    # values are counts
    $(@el).empty()
    limit_categories.each((limcat) =>
      even = (limit_categories.models.indexOf(limcat)%2 == 0)
      # make two columns side-by-side
      if (even)
        $(@el).append("<tr></tr>")

      limit_category_view = new Application.LimitCategoryView
        name: limcat.get('name')
        value: collection[limcat.get('id')]

      contents = limit_category_view.render()
      $('tr',$(@el)).last().append(contents)
    )
