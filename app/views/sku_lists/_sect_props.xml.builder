xml.w :p do
  xml.w :pPr do
    xml.w :sectPr do
      if include_footer_ref # the first time
        xml.w :footerReference, "w:type" => "default", "r:id" => "rId7"
      end
      xml.w :type, "w:val" => "continuous"
      xml.w :pgSz, "w:w" => "15840", "w:h" => "12240", "w:orient" => "landscape"
      xml.w :pgMar, "w:top" => "990", "w:right" => "1440", "w:bottom" => "1080", "w:left" => "1440", "w:header" => "708", "w:footer" => "708", "w:gutter" => "0"
      xml.w :cols, "w:num" => num_cols.to_s, "w:space" => "708"
      xml.w :printerSettings, "r:id" => rId
    end
  end
end
