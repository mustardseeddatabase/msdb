module OptionsHelper
  def category_options(options)
    # food categories first, followed by non-food categories
    options_for_select @categories.sort_by{|cat| [(cat.name != "Food").to_s,cat.descriptor]}.collect { |cat| [cat.descriptor, cat.id] }, options[:selected]
  end
end
