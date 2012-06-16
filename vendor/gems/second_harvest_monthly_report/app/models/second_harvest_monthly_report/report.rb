module SecondHarvestMonthlyReport
  class Report < ::Report
    attr_accessor :for_date, :title

    def self.template
      # prepending "/" to the template path is necessary b/c ActionController removes the leading "/", so add a second one that it can have its way with!
      "/" + SecondHarvestMonthlyReport::Engine.root.join(template_path).to_s
    end

    def self.template_path
      "app/document_templates/second_harvest_monthly_report"
    end
  end
end
