module SummaryReport
  class Report < ::Report
    attr_accessor :for_date, :title, :client_collection, :household_collection, :distribution_collection

    def initialize(date = 1.month.ago)
      @for_date = date
      households = Distribution.in_month(date.year, date.month).includes(:household => :clients).map(&:household)
      @household_collection = HouseholdCollection.new(households)
      @client_collection = ClientCollection.new(@household_collection.clients)
      @distribution_collection = DistributionCollection.new(date)
    end

    def self.template
      # prepending "/" to the template path is necessary b/c ActionController removes the leading "/", so add a second one that it can have its way with!
      "/" + SummaryReport::Engine.root.join(template_path).to_s
    end

    def self.template_path
      "app/document_templates/summary_report"
    end

    # this method assembles the data for the period summary table in the report
    def period_summary
      [
      ['Days of distribution', distribution_collection.days_of_distribution],
      ['Unique households', household_collection.length],
      ['Unique residents', client_collection.length],
      ['Distributions', distribution_collection.length],
      ['New households', household_collection.new(for_date).length],
      ['New residents', household_collection.new_clients(for_date)],
      ['Lbs. of food distributed', distribution_collection.lbs_of_food_distributed]
      ]
    end

    def age_demographics
      client_collection.counts_by_age_group_and_gender
    end

    def race_demographics
      client_collection.counts_by_race_and_gender
    end

    def government_assistance
      household_collection.government_assistance
    end

    def special_circumstances
      household_collection.special_circumstances
    end

    def income_ranges
      household_collection.income_ranges
    end

    def zip_codes
      household_collection.zip_codes
    end

    def family_structures
      household_collection.family_structures
    end
  end
end
