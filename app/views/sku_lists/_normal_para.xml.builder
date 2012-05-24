xml.w :p do
  xml.w :pPr do
    xml.w :tabs do
      xml.w :tab, "w:val" => "right", "w:pos" => "3024"
    end
  end
  xml.w :r do
    xml.w :t, "#{item.description} (#{item.weight_oz} oz)"
  end
  xml.w :r do
    xml.w :tab
    xml.w :t, item.sku
  end
end
