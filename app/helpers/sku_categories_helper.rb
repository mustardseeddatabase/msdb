module SkuCategoriesHelper
  def category_group
    header_factor = 3
    average_column_length = (@categorized_items.values.flatten.count.to_f/4)
    average_column_length += (@categorized_items.keys.count * header_factor).to_f/4
    average_column_length = [average_column_length.round, 3].max # for the test suite which has very small data sets
    haml_tag :table, {:style => 'margin-bottom: 24px'} do
      haml_tag :tr do
        4.times do
          column_length = 0
          haml_tag :td, {:valign => :top} do
            haml_tag :table, {:style => 'margin-right:24px'} do

              until @categorized_items.empty? do
                category = @categorized_items.keys.sort[0]
                column_length += header_factor
                break if column_length > average_column_length
                items = @categorized_items[category]
                haml_tag :tr do
                  haml_tag :td do
                    haml_tag :h2, "#{category}"
                  end #/td

                while !items.empty? do
                  break if column_length > average_column_length
                  column_length += 1
                  item = items.shift
                  haml_tag :tr do
                    haml_tag :td, "#{item.description}(#{item.weight_oz} oz)"
                    haml_tag :td, "#{item.sku}"
                  end #/tr
                end #/while

                @categorized_items.delete(category) if items.empty? # remove category when all items are rendered

                end #/tr
              end #/until

            end #/table
          end #/td
        end #/4.times
      end #/tr
    end #/table
  end #/def

end
