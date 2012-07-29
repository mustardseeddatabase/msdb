class HouseholdCheckin < ActiveRecord::Base
  belongs_to :household
  has_many :client_checkins

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
