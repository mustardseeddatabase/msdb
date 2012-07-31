module ApplicationHelper
  def submit_or_return_to(return_path)
    haml_tag :table, {:style => 'padding-top:30px'} do
      haml_tag :tr do
        haml_tag :td, {:width => '180px'} do
          haml_tag :input, {:type => 'submit', :value => 'Save'}
        end
        haml_tag :td do
          haml_tag :a, "Cancel", {:href => return_path}
        end
      end
    end
  end

  def focus(input)
    haml_tag :script, "$(function(){$('##{input}').focus()})"
  end

end
