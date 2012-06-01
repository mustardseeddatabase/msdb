class ReportsController < ApplicationController
  def index
  end

  def show
    @date = Date.today
    @month = Date::MONTHNAMES[1.month.ago.month]
    @parish = "Saint Bernard"
    @agency_name = "Community Center of St. Bernard"
    @physical_address = "1111 LeBeau St., Arabi, LA 70032"
    @contact_person = "Je'Nae Bailey"
    @phone = "(504) 281-2512"

    respond_to do |format|
      format.docx {render :docx => "second_harvest_monthly", :template=> "document_templates/second_harvest_monthly_report", :from_template => true}
    end
  end
end
