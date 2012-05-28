xml.instruct! :xml, :standalone => 'yes'

xml.w :document, document_namespaces do # document_namespaces comes from the Doccex engine
  xml.w :body do

    xml << render(:partial => 'heading1.xml', :locals => {:text => "SKU List", :rId => @rels.next_id(:printer), :footerReference => @rels.next_id(:footer)})

    sku_list_items.each do |list_item|
      if list_item.kind_of?(Item)
        xml << render(:partial => 'normal_para.xml', :locals => {:item => list_item})
      else
        xml << render(:partial => 'heading2.xml', :locals => {:text => list_item[:category]})
      end
    end
    xml << render(:partial => 'four_column_section_properties.xml', :locals => {:rId => @rels.next_id(:printer)})

  end
end
