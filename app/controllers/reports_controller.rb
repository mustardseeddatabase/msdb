class ReportsController < ApplicationController
  def index
    @second_harvest_report = SecondHarvestMonthlyReport::Report.new(:for_date => 1.month.ago) # the most recent report is the end of last month. Set that as the default
  end
end
