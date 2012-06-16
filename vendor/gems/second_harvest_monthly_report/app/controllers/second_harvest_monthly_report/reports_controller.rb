module SecondHarvestMonthlyReport
  class ReportsController < ApplicationController
    def show
      @date = Date.today
      date_params = [params[:report]["for_date(1i)"].to_i,params[:report]["for_date(2i)"].to_i,params[:report]["for_date(3i)"].to_i]
      date = Date.new(*date_params)
      @month = "#{Date::MONTHNAMES[date.month]} #{date.year}"
      @parish = "Saint Bernard"
      @agency_name = "Community Center of St. Bernard"
      @agency_number = "A10147"
      @address = "1111 LeBeau St., Arabi, LA 70032"
      @contact = "Je'Nae Bailey"
      @phone = "(504) 281-2512"
      @days_and_hours = "T,W,Th, 11am - 3pm"

      @demographic, @clients_with_errors = Distribution.demographic_for_month(date)

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
        format.docx do
          render :docx => "second_harvest_monthly",
                 :template=> Report.template,
                 :from_template => true
        end

        format.json do
          render :json => @clients_with_errors.to_json(
                    :methods => [:missing_gender_flag, :missing_race_flag, :missing_birthdate_flag, :first_last_name]
                  )
        end
      end
    end
  end
end
