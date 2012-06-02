class ReportsController < ApplicationController
  def index
  end

  def show
    @date = Date.today
    @month = Date::MONTHNAMES[1.month.ago.month]
    @parish = "Saint Bernard"
    @agency_name = "Community Center of St. Bernard"
    @agency_number = "?"
    @address = "1111 LeBeau St., Arabi, LA 70032"
    @contact = "Je'Nae Bailey"
    @phone = "(504) 281-2512"
    @days_and_hours = "T,W,Th, 10am - 2pm"
    @demographic = {}
    [:new, :continued, :total].each do |arg|
      @demographic[arg] = {}
      [:household, :children, :adults, :seniors, :homeless, :total].each do |cat|
        @demographic[arg][cat] = rand(30).to_s
      end
    end

    [:male, :female].each do |arg|
      @demographic[arg] = {}
      [:aa, :w, :hisp, :asian, :unk, :total].each do |cat|
        @demographic[arg][cat] = rand(30).to_s
      end
    end
    [:aa, :w, :hisp, :asian, :unk, :total].each do |cat|
      @demographic[:total][cat] = rand(30).to_s
    end

    @number_of_boxes = rand(50).to_s
    @average_weight = rand(12).to_s
    @number_of_breakfasts = "N/A"
    @number_of_lunches = "N/A"
    @number_of_dinners = "N/A"
    @number_of_snacks = "N/A"

    @total_shfb_weight = rand(500)
    @total_weight_purchased = rand(500)
    @total_other_weight = rand(500)
    @grand_total = (@total_shfb_weight + @total_weight_purchased + @total_other_weight).to_s
    @total_shfb_weight = @total_shfb_weight.to_s
    @total_weight_purchased = @total_weight_purchased.to_s
    @total_other_weight = @total_other_weight.to_s

    @questionnaires_count = rand(100).to_s


    respond_to do |format|
      format.docx {render :docx => "second_harvest_monthly", :template=> "document_templates/second_harvest_monthly_report", :from_template => true}
    end
  end
end
