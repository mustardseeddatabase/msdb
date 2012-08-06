class QualificationDocument < ActiveRecord::Base
  include BooleanRender

  Types = {
      'res' => 'ResQualdoc',
      'inc' => 'IncQualdoc',
      'gov' => 'GovQualdoc',
      'id'  => 'IdQualdoc'
    }

  mount_uploader :docfile, DocfileUploader

  def threshold
    self.class::ExpiryThreshold
  end

  def expired?
    date.nil? || (date < threshold.months.ago.to_date)
  end

  # returns true if the date will expire in the next two weeks
  def expiring?
    max = threshold.months.ago.advance(:weeks => 2).to_date
    min = threshold.months.ago.to_date
    !date.nil? && ((date >= min) && (date <= max))
  end

  def expiry_date
    date.advance(:months => threshold).to_date unless date.nil?
  end

  def current?
    expiry_date && expiry_date.future?
  end

  def information_status
    case
    when date.nil?
      'date not available'
    when expired?
      "expired on #{expiry_date.to_formatted_s(:rfc822)}"
    when expiring?
      "expires on #{expiry_date.to_formatted_s(:rfc822)}"
    else
      'current'
    end
  end

  def qualification_vector
    {:association_id => association_id, :id => id, :description => self.class::Description.capitalize, :doctype => document_type, :expired? => expired?, :expiry_date => expiry_date, :status => information_status, :warnings => warnings || 0, :date => date, :doc_link => doc_link}
  end

  def doc_link
    docfile && docfile.url
  end

  def in_db?
    docfile.present?
  end

  def document_type
    type.tableize.split("_")[0]
  end

  def belongs_to?(client)
    belongs_to_client = (document_type == "id") && (self.client == client)
    belongs_to_household = (["inc", "res", "gov"].include?(document_type)) && (household.clients.include? client)
    belongs_to_client || belongs_to_household
  end

end
