class Address < ActiveRecord::Base
  has_one :household
  scope :matching, lambda{ |address_hash| with_fields_matching(address_hash)}

  def self.with_fields_matching(address_hash)
    a = where("address LIKE ?", '%'+address_hash[:address]+'%') unless address_hash[:address].blank?
    b = where("city    LIKE ?", '%'+address_hash[:city]+'%')    unless address_hash[:city].blank?
    c = where("zip     LIKE ?", '%'+address_hash[:zip]+'%')     unless address_hash[:zip].blank?
    [a, b, c].compact.inject{|x,y| x.merge y }
  end

  def self.street_names_matching(street_name_fragment)
    select('address').where("address LIKE '%#{street_name_fragment}%'").map(&:street_name).uniq
  end

  def self.cities_matching(city_fragment)
    select('DISTINCT city').where("city LIKE '#{city_fragment}%'").map(&:city)
  end

  def self.zip_codes_matching(zip_fragment)
    select('DISTINCT zip').where("zip LIKE '#{zip_fragment}%'").map(&:zip)
  end

  def <=>(other)
    compare = comparison_vector_for(self) <=> comparison_vector_for(other)
    compare || -1
  end

  def complete?
    [address, city, zip].all?(&:present?)
  end

  def street_name
    if has_po_box? || address.blank?
      ''
    else
      address.match(/\D*$/)[0].lstrip
    end
  end

  def street_number
    if has_po_box? || !address || !address.match(/^\d+/)
      0
    else
      address.match(/^\d+/)[0].to_i
    end
  end

  def to_s
    apartment = "apt #{apt}" unless apt.blank?
    [address, apartment, city, zip].compact.join(', ')
  end

  def has_po_box?
    !!( self.address && self.address.gsub(/[\. ]/,'').downcase.match(/^po/) )
  end

  # a binary value for sorting
  def has_po_box
    has_po_box? ? 1 : 0
  end

  def po_box_number
    if has_po_box?
      self.address.gsub(/[\. ]/,'').downcase.match(/^po(box)?(\d*)/)[2]
    else
      ''
    end
  end


private
  def comparison_vector_for(receiver)
    ['zip','city','street_name','street_number'].map{|attr| receiver.try(attr) || ''}
  end

end
