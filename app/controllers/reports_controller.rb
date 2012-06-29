class ReportsController < ApplicationController
  def index
    # An example of how to instantiate a report object for use in the view, after you have created a report with the generator
    # @second_harvest_report = SecondHarvestMonthlyReport::Report.new(:for_date => 1.month.ago)
    @summary_report = SummaryReport::Report.new
  end
end
