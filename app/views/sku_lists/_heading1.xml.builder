xml.w :p do
  xml.w :pPr do
    xml.w :pStyle, "w:val" => "Heading1"
    xml.w :spacing, "w:before" => "0", "w:after" => "480"
    xml.w :sectPr do
      begin
        xml.w :footerReference, "w:type" => "default", "r:id" => footerReference # if provided it should be of form "rIdn"
      rescue; end # just ignore if no footerReference is provided
      xml.w :type, "w:val" => "continuous"
      xml.w :pgSz, "w:w" => "15840", "w:h" => "12240", "w:orient" => "landscape"
      xml.w :pgMar, "w:top" => "1800", "w:right" => "1440", "w:bottom" => "1800", "w:left" => "1440", "w:header" => "708", "w:footer" => "708", "w:gutter" => "0"
      xml.w :cols, "w:space" => "708"
      xml.w :printerSettings, "r:id" => rId
    end
  end
  xml.w :r do
    xml.w :t, text
  end
end
