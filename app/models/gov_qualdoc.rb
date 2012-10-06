class GovQualdoc < QualificationDocument
  belongs_to :household, :foreign_key => :association_id
  ExpiryThreshold = 6 # units are months
  Description = "government income verification information"

  include HouseholdQualdoc
end
