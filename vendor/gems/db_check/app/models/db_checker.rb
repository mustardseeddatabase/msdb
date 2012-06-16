class DbChecker
  def self.households_multiple_heads
    [Household.with_multiple_heads, :household, "Households with multiple heads"]
  end

  def self.households_no_head
    [Household.with_no_head, :household, "Households with no head of household"]
  end

  def self.households_no_addresses
    [Household.with_no_addresses, :household, "Households with no temporary or permanent address"]
  end

  def self.clients_no_household
    [Client.with_no_household, :client, "Clients with no associated household"]
  end

  def self.clients_no_addresses
    [Client.with_no_address, :client, "Clients with no address"]
  end

  def self.donor_no_donations
    [Donor.with_no_donations, :donor, "Donors with no donations"]
  end

  def self.donor_duplicate_org_names
    [Donor.with_duplicate_org_names, :donor, "Donors with duplicate organization names"]
  end

  def self.households_with_clients_with_no_first_or_last_name
    [Client.with_no_first_or_last_name, :household, "Households with clients with neither a first name nor a last name"]
  end

end
