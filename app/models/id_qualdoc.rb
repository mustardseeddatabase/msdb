class IdQualdoc < QualificationDocument
  belongs_to :client, :foreign_key => :association_id
  ExpiryThreshold = 12 # units are months
  Description = "identification verification information"

  def belongs_to?(client)
    self.client == client
  end

end
