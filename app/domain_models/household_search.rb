# HouseholdSearch manages all the different ways in which the search
# parameters are used, in sql or ruby matching
# and passed around as json format to facilitate
# returning to a particular search result
# and formatted for rendering on the index page
class HouseholdSearch
  attr_accessor :city, :zip, :address, :client_name, :params

  HumanizedAttributes =
    { :city => "city:",
      :zip => "zip code:",
      :address => "street name:",
      :client_name => "client last name:" }

  # params is a hash or a json string
  def initialize(hash_or_json)
    @params = hash_or_json.is_a?(String) ? HouseholdSearch.extract_params(hash_or_json) : hash_or_json
    @city, @zip, @address, @client_name = [ params[:city], params[:zip], params[:address], params[:client_name] ] unless params.blank?
  end

  def has_address_params?
    [!!:city, !!:zip, !!:address].any?
  end

  def has_client_params?
    client_name.present?
  end

  def self.extract_params(string)
    JSON.parse(string).inject({}){|hash,(k,v)| hash[k.to_sym] = v; hash}
  end

  def to_params
    {:household_search => @params}
  end

  def blank?
    [city, zip, address, client_name].all?(&:blank?)
  end

  def search_terms
    result = HumanizedAttributes.inject({}) { |hash, (attr, hum_attr)| (hash[hum_attr] = self.send(attr)) unless self.send(attr).blank?; hash }

    def result.to_s
      self.to_a.map {|field| field.join(" ")}. join(", ")
    end

    result
  end
end
