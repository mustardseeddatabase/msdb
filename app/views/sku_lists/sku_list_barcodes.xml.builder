xml.instruct! :xml, :standalone => 'yes'

xml.w :document, document_namespaces do # document_namespaces comes from the Doccex engine
  xml.w :body do

    xml << render(:partial => 'heading1.xml', :locals => {:text => "SKU List Barcodes", :rId => @rels.next_id(:printer), :footerReference => @rels.next_id(:footer)})

    @categories.each do |category|
      xml << render(:partial => 'heading2.xml', :locals => {:text => (category && category.descriptor) || "No Category"})
      if @categories.index(category).zero?
        xml << render(:partial => 'sect_props.xml', :locals => {:include_footer_ref => true, :num_cols => 1, :rId => @rels.next_id(:printer), :footerReference => @rels.next_id(:footer)})
      else
        xml << render(:partial => 'sect_props.xml', :locals => {:include_footer_ref => false, :num_cols => 1, :rId => @rels.next_id(:printer)})
      end
      xml << render(:partial => 'table.xml', :locals => {:items => @items.select{|item| item.category == category}})
      xml << render(:partial => 'sect_props.xml', :locals => {:include_footer_ref => false, :num_cols => 2, :rId => @rels.next_id(:printer)})
    end
    xml << render(:partial => 'four_column_section_properties.xml', :locals => {:rId => @rels.next_id(:printer)})

  end
end

