module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within ([^:]+)$/ do |step, parent|
  with_scope(parent) { When step }
end

# Multi-line step scoper
When /^(.*) within ([^:]+):$/ do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

module AutocompleteHelpers
  def fill_in_autocomplete(element_id, value)
    page.execute_script %Q{$('input##{element_id}').val('#{value}').keydown()}
  end

  def choose_autocomplete(text)
    find('div.acResults ul').should have_content(text)
    page.execute_script("$('div.acResults ul li:contains(\"#{text}\")').trigger('mouseenter').click()")
  end
end

World(AutocompleteHelpers)
