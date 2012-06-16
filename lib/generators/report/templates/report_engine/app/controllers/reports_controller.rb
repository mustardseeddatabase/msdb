module NAMESPACE
  class ReportsController < ApplicationController
    skip_before_filter :check_permissions, :only => :show
    def show
      if permitted?(request.parameters['controller'], request.parameters['action'])
        @date = Date.today
        date_params = [params[:report]["for_date(1i)"].to_i,params[:report]["for_date(2i)"].to_i,params[:report]["for_date(3i)"].to_i]
        date = Date.new(*date_params)
        @month = "#{Date::MONTHNAMES[date.month]} #{date.year}"
        @month_receivables = "$" + rand(10000).to_s + ".00"
        @month_expenses = "$" + rand(10000).to_s + ".00"
        @month_beginning_inventory = "$" + rand(10000).to_s + ".00"
        @end_of_month_inventory = "$" + rand(10000).to_s + ".00"
        @avg_days = rand(30).to_s

        respond_to do |format|
          format.docx do
            render :docx => "report_name",
                   :template=> Report.template,
                   :from_template => true
          end
        end
      else
        flash[:warn] = "You haven't been granted permission to generate that report"
        redirect_to main_app.reports_path
      end
    end #/def
  end #/class
end #/module

