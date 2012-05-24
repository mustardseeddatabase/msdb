xml.instruct! :xml, :standalone => 'yes'

xml.w :document, "xmlns:mo" => "http://schemas.microsoft.com/office/mac/office/2008/main", "xmlns:ve" => "http://schemas.openxmlformats.org/markup-compatibility/2006", "xmlns:mv" => "urn:schemas-microsoft-com:mac:vml", "xmlns:o" => "urn:schemas-microsoft-com:office:office", "xmlns:r" => "http://schemas.openxmlformats.org/officeDocument/2006/relationships", "xmlns:m" => "http://schemas.openxmlformats.org/officeDocument/2006/math", "xmlns:v" => "urn:schemas-microsoft-com:vml", "xmlns:wp" => "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing", "xmlns:w10" => "urn:schemas-microsoft-com:office:word", "xmlns:w" => "http://schemas.openxmlformats.org/wordprocessingml/2006/main", "xmlns:wne" => "http://schemas.microsoft.com/office/word/2006/wordml" do
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
