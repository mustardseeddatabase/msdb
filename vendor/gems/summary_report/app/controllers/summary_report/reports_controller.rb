module SummaryReport
  class ReportsController < ApplicationController

    skip_before_filter :check_permissions, :only => :show
    def show
      if permitted?(request.parameters['controller'], request.parameters['action'])
        @date = Date.today
        date_params = [params[:report]["for_date(1i)"].to_i,params[:report]["for_date(2i)"].to_i,params[:report]["for_date(3i)"].to_i]
        date = Date.new(*date_params)
        @month = "#{Date::MONTHNAMES[date.month]} #{date.year}"
        report = SummaryReport::Report.new(date)
        @summary_items = report.period_summary
        @age_demographics = report.age_demographics
        @race_demographics = report.race_demographics
        @government_assistance = report.government_assistance
        @special_circumstances = report.special_circumstances
        @income_ranges = report.income_ranges
        @zip_codes = report.zip_codes
        @family_structures = report.family_structures

        respond_to do |format|
          format.docx { render :docx => "summary_report", :template => 'summary_report/show' }
        end
      else
        flash[:warn] = "You haven't been granted permission to generate that report"
        redirect_to main_app.reports_path
      end
    end #/def
  end #/class
end #/module

