xml.w :tr do
  xml.w :trPr do
    xml.w :cantSplit
    xml.w :trHeight, "w:val" => "432", "w:hRule" => "exact" # about 0.3" height
  end
  xml.w :tc do
    xml.w :tcPr do
      xml.w :tcW,"w:w" => "2886","w:type" => "dxa"
      xml.w :vAlign, "w:val" => "center"
    end
    xml.w :p do
      xml.w :r do
        xml.w :t, "#{item.description} (#{item.weight_oz} oz)"
      end
    end
  end
  xml.w :tc do
    xml.w :tcPr do
      xml.w :tcW,"w:w" => "3456","w:type" => "dxa"
      xml.w :vAlign, "w:val" => "right"
    end

    rid, img_index = @rels.next_id(:image)
    barcode = RBarcode::Code39.new(:text => item.sku.to_s)
    barcode.to_img(Rails.root.join("tmp/docx/word/media/image#{img_index}.png").to_s,100,18,:right)
    xml << render(:partial => 'barcode_image.xml', :locals => {:rid => rid, :index => @rels.next_image_index })
  end
end
