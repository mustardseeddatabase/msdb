class DbChecker
  def self.households_multiple_heads
    [Household.with_multiple_heads, :household]
  end

  def self.households_no_head
    [Household.with_no_head, :household]
  end

  def self.households_no_addresses
    [Household.with_no_addresses, :household]
  end

  def self.clients_no_household
    [Client.with_no_household, :client]
  end

  def self.clients_no_addresses
    [Client.with_no_address, :client]
  end

  def self.donor_no_donations
    [Donor.with_no_donations, :donor]
  end

end
