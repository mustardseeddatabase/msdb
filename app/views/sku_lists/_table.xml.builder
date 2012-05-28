xml.w :tbl do
  xml.w :tblPr do
    xml.w :tblStyle, "w:val" =>"TableGrid"
    xml.w :tblW, "w:w" =>"0", "w:type" =>"auto"
    xml.w :tblBorders do
      xml.w :top, "w:val" =>"none", "w:sz" =>"0", "w:space" =>"0", "w:color" =>"auto"
      xml.w :left, "w:val" =>"none", "w:sz" =>"0", "w:space" =>"0", "w:color" =>"auto"
      xml.w :bottom, "w:val" =>"none", "w:sz" =>"0", "w:space" =>"0", "w:color" =>"auto"
      xml.w :right, "w:val" =>"none", "w:sz" =>"0", "w:space" =>"0", "w:color" =>"auto"
      xml.w :insideH, "w:val" =>"none", "w:sz" =>"0", "w:space" =>"0", "w:color" =>"auto"
      xml.w :insideV, "w:val" =>"none", "w:sz" =>"0", "w:space" =>"0", "w:color" =>"auto"
    end
    xml.w :tblLook, "w:val" =>"04A0", "w:firstRow" =>"1", "w:lastRow" =>"0", "w:firstColumn" =>"1", "w:lastColumn" =>"0", "w:noHBand" =>"0", "w:noVBand" =>"1"
  end
  xml.w :tblGrid do
    xml.w :gridCol, "w:w" =>"2886"
    xml.w :gridCol, "w:w" =>"3456"
  end

  items.sort_by(&:description).each do |item|
    xml << render(:partial => 'table_row.xml.builder', :locals => {:item => item})
  end
end
