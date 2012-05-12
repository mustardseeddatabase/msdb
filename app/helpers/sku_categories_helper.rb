module SkuCategoriesHelper
  def category_group
    header_factor = 3
    average_column_length = (@items.count.to_f/4)
    average_column_length += (@categories.count * header_factor).to_f/4
    average_column_length = [average_column_length.round, 3].max # for the test suite which has very small data sets
    haml_tag :table, {:style => 'margin-bottom: 24px'} do
      haml_tag :tr do
        4.times do
          column_length = 0
          haml_tag :td, {:valign => :top} do
            haml_tag :table, {:style => 'margin-right:24px'} do

              until @categories.empty? do
                category = @categories[0]
                column_length += header_factor
                break if column_length > average_column_length
                items = @items.select{|i| i.category == category}.sort_by(&:description)
                haml_tag :tr do
                  haml_tag :td do
                    haml_tag :h2, "#{category && category.descriptor || 'No category'}"
                  end #/td

                while !items.empty? do
                  break if column_length > average_column_length
                  column_length += 1
                  item = items.shift
                  @items.delete_if{|i| i == item}
                  haml_tag :tr do
                    haml_tag :td, "#{item.description}(#{item.weight_oz} oz)"
                    haml_tag :td, "#{item.sku}"
                  end #/tr
                end #/while

                @categories.delete_at(0) if items.empty? # remove category when all items are rendered

                end #/tr
              end #/until

            end #/table
          end #/td
        end #/4.times
      end #/tr
    end #/table
  end #/def

end
