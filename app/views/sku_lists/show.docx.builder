xml.instruct! :xml, :standalone => 'yes'

xml.w :document, document_namespaces do # document_namespaces is a helper from the Doccex engine
  xml.w :body do

    xml << heading1("SKU List")
    footer = Footer.new(render :partial => 'footer.xml')
    xml << section_properties(:include_footer => true)

    @categorized_items.sort.each do |category, items|
      xml << heading2(category)

      items.each do |item|
        xml << single_tabbed_paragraph({ :tab => {:val => 'right', :pos => "3024"},
                                         :contents => [ "#{item.description} (#{item.weight_oz} oz)", item.sku] })
      end
    end

    xml << section_properties(:num_cols => 4)

    # the following paragraph and section properties seems to be necessary in order
    # for MSWord not to append a spurious page
    xml.w :p do
      xml.w :pPr
    end
    xml.w :sectPr do
      xml.w :type, "w:val" => "continuous"
      xml.w :pgSz, "w:w" => "15840", "w:h" => "12240", "w:orient" => "landscape"
      xml.w :pgMar, "w:top" => "990", "w:right" => "1440", "w:bottom" => "1080", "w:left" => "1440", "w:header" => "708", "w:footer" => "708", "w:gutter" => "0"
      xml.w :cols, "w:space" => "708"
    end

  end
end
