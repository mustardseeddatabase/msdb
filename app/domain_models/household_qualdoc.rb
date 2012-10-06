module HouseholdQualdoc
  def belongs_to?(client)
    household.clients.include?(client)
  end
end
