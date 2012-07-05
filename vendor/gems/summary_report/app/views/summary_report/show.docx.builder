xml.instruct! :xml, :standalone => 'yes'

xml.w :document, document_namespaces do # document_namespaces is a helper from the Doccex engine
  xml.w :body do

    xml << title("Mustard Seed Database\rSummary Report\rFor #{@month}")

    # the following report sections are implemented in the app/helpers/summary_report/reports_helper.rb file
    xml << period_summary
    xml << age_demographics
    xml << race_demographics
    xml << other_government_assistance
    xml << special_circumstances
    xml << income_ranges
    xml << zip_codes
    xml << family_structures


    # the following paragraph and section properties seems to be necessary in order
    # for MSWord not to append a spurious page
    xml.w :p do
      xml.w :pPr
    end
    xml.w :sectPr do
      xml.w :type, "w:val" => "continuous"
      xml.w :pgSz, "w:h" => "15840", "w:w" => "12240"
      xml.w :pgMar, "w:top" => "1440", "w:right" => "1800", "w:bottom" => "1440", "w:left" => "1800", "w:header" => "708", "w:footer" => "708", "w:gutter" => "0"
      xml.w :cols, "w:space" => "708"
    end

  end
end
