# note: tableless model
# supports the form helpers in the reports#index view
# provides a 'home' for report parameters for particular reports, 
# that may be defined in the reports#index view
class Report
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :for_date, :title

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
