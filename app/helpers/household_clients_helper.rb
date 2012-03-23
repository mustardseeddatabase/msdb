module HouseholdClientsHelper
  def address(temp_or_perm)
    address = @household.send(temp_or_perm.to_s + '_address')
    [address.address, address.city, address.zip].reject(&:blank?).join(", ") unless address.nil?
  end
end
