class QualificationDocument < ActiveRecord::Base
  include BooleanRender

  Types = {
      'res' => 'ResQualdoc',
      'inc' => 'IncQualdoc',
      'gov' => 'GovQualdoc',
      'id'  => 'IdQualdoc'
    }

  mount_uploader :docfile, DocfileUploader

  def self.update_collection(docs)
    grouped_docs = docs.group_by{|doc| !doc['id'].nil? && doc['id'] != "null"}
    docs_for_update = grouped_docs[true] || []
    new_docs = grouped_docs[false] || []

    docs_for_update.each do |doc|
      qualdoc = find(doc['id'])
      qualdoc.update_attributes(doc.slice('date', 'warnings', 'confirm'))
    end

    new_docs.each do |doc|
      doctype = Types[doc['doctype']]
      qualdoc = doctype.constantize.send('create',doc.slice('date','warnings','association_id', 'confirm'))
    end
  end

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
     {:association_id => association_id,
     :date => date,
     :description => self.class::Description.capitalize,
     :doc_link => doc_link,
     :doctype => document_type,
     :expired? => expired?,
     :expiry_date => expiry_date,
     :id => id,
     :status => information_status,
     :warnings => warnings || 0}
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

  def remove_file
    self.remove_docfile = true
    save
  end

end
