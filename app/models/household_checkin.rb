class HouseholdCheckin < ActiveRecord::Base
  belongs_to :household
  has_many :client_checkins

  def self.extract_attributes_from_docs(docs)
    docs.inject({}) do |hash, doc|
      hash[doc['doctype'] + '_warn'] = doc['warned']
      hash['household_id'] ||= doc['association_id']
      hash
    end
  end

  def primary_client_checkin
    client_checkins.where('client_checkins.primary IS TRUE').first
  end

  def primary_client
    primary_client_checkin.client
  end

  def clean?
    [!res_warn, !inc_warn, !gov_warn].all?
  end

  def clean_clients?
    client_checkins.map(&:clean?).all?
  end

  def totally_clean?
    clean? && clean_clients?
  end
end
