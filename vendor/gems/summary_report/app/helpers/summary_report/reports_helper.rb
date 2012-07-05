module SummaryReport::ReportsHelper

  # note that 'heading1' and 'table' are helpers supplied by the doccex gem
  # each of the methods in this helper returns an xml string for inclusion in document.xml
  # there are 1440 twips units per inch, 9360 in 6 1/2 inches (8 1/2" page with 1" margins)

  def period_summary
    table_header = ["Category", "Total"]

    xml = heading1("Period Summary")

    xml << table( :style => "TableGrid",
                  :collection => @summary_items,
                  :obj_name => :summary_item,
                  :row => {:height => {:twips => 300}, :hRule => 'exact'},
                  :header_row => table_header,
                  :cols => [ {:align => 'top', :twips => 3258, :cell_contents => 'summary_report/period_summary/cell1_contents'},
                             {:align => 'top', :twips => 1710, :cell_contents => 'summary_report/period_summary/cell2_contents'}])
  end


  def age_demographics
    table_header = ["Age group", "Male", "Female", "Unknown", "Total"]

    xml = heading1("Age demographics for food recipients in period")

    xml << table( :style => "TableGrid",
                  :collection => @age_demographics,
                  :obj_name => :age_demographic,
                  :row => {:height => {:twips => 300}, :hRule => 'exact'},
                  :header_row => table_header,
                  :cols => [ { :align => 'top', :twips => 1710, :cell_contents => 'summary_report/age_demographics/cell1_contents'},
                             { :align => 'top', :twips => 1710, :cell_contents => 'summary_report/age_demographics/cell2_contents'},
                             { :align => 'top', :twips => 1710, :cell_contents => 'summary_report/age_demographics/cell3_contents'},
                             { :align => 'top', :twips => 1710, :cell_contents => 'summary_report/age_demographics/cell4_contents'},
                             { :align => 'top', :twips => 1710, :cell_contents => 'summary_report/age_demographics/cell5_contents'}])
  end


  def race_demographics
    table_header = ["Race", "Male", "Female", "Unknown", "Total"]

    xml = heading1("Race demographics for food recipients in period")

    xml << table( :style => "TableGrid",
                  :collection => @race_demographics,
                  :obj_name => :race_demographic,
                  :row => {:height => {:twips => 300}, :hRule => 'exact'},
                  :header_row => table_header,
                  :cols => [ { :align => 'top', :twips => 2110, :cell_contents => 'summary_report/race_demographics/cell1_contents'},
                             { :align => 'top', :twips => 1610, :cell_contents => 'summary_report/race_demographics/cell2_contents'},
                             { :align => 'top', :twips => 1610, :cell_contents => 'summary_report/race_demographics/cell3_contents'},
                             { :align => 'top', :twips => 1610, :cell_contents => 'summary_report/race_demographics/cell4_contents'},
                             { :align => 'top', :twips => 1610, :cell_contents => 'summary_report/race_demographics/cell5_contents'}])
  end

  def other_government_assistance
    table_header = ["Receiving government aid in form of:", "Number of households"]

    xml = heading1("Household recipients in period with other governmental assistance")

    xml << table( :style => "TableGrid",
                  :collection => @government_assistance,
                  :obj_name => :government_assistance,
                  :row => {:height => {:twips => 300}, :hRule => 'exact'},
                  :header_row => table_header,
                  :cols => [ { :align => 'top', :twips => 5000, :cell_contents => 'summary_report/government_assistance/cell1_contents'},
                             { :align => 'top', :twips => 2800, :cell_contents => 'summary_report/government_assistance/cell2_contents'}])
  end

  def special_circumstances
    table_header = ["At least one member of the household is...", "Number of households"]

    xml = heading1("Household recipients in period with special circumstances")

    xml << table( :style => "TableGrid",
                  :collection => @special_circumstances,
                  :obj_name => :special_circumstance,
                  :row => {:height => {:twips => 300}, :hRule => 'exact'},
                  :header_row => table_header,
                  :cols => [ { :align => 'top', :twips => 5000, :cell_contents => 'summary_report/special_circumstances/cell1_contents'},
                             { :align => 'top', :twips => 2800, :cell_contents => 'summary_report/special_circumstances/cell2_contents'}])
  end

  def income_ranges
    table_header = ["Gross annual income", "Number of households", "Number of residents"]

    xml = heading1("Household income ranges for recipients in period")

    xml << table( :style => "TableGrid",
                  :collection => @income_ranges,
                  :obj_name => :income_range,
                  :row => {:height => {:twips => 300}, :hRule => 'exact'},
                  :header_row => table_header,
                  :cols => [ { :align => 'top', :twips => 3120, :cell_contents => 'summary_report/income_ranges/cell1_contents'},
                             { :align => 'top', :twips => 3120, :cell_contents => 'summary_report/income_ranges/cell2_contents'},
                             { :align => 'top', :twips => 3120, :cell_contents => 'summary_report/income_ranges/cell3_contents'}])
  end

  def zip_codes
    table_header = ["Zip code", "Number of households", "Number of residents"]

    xml = heading1("Distribution by zip code of household recipients in period")

    xml << table( :style => "TableGrid",
                  :collection => @zip_codes,
                  :obj_name => :zip_code,
                  :row => {:height => {:twips => 300}, :hRule => 'exact'},
                  :header_row => table_header,
                  :cols => [ { :align => 'top', :twips => 3120, :cell_contents => 'summary_report/zip_codes/cell1_contents'},
                             { :align => 'top', :twips => 3120, :cell_contents => 'summary_report/zip_codes/cell2_contents'},
                             { :align => 'top', :twips => 3120, :cell_contents => 'summary_report/zip_codes/cell3_contents'}])
  end

  def family_structures
    table_header = ["Family structure", "Number of households"]

    xml = heading1("Household family structure for recipients in period")

    xml << table( :style => "TableGrid",
                  :collection => @family_structures,
                  :obj_name => :family_structure,
                  :row => {:height => {:twips => 300}, :hRule => 'exact'},
                  :header_row => table_header,
                  :cols => [ { :align => 'top', :twips => 3120, :cell_contents => 'summary_report/family_structures/cell1_contents'},
                             { :align => 'top', :twips => 3120, :cell_contents => 'summary_report/family_structures/cell2_contents'}])
  end
end
