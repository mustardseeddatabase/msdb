class AddressesController < ApplicationController

  def autocomplete
    matches = Address.zip_codes_matching(params[:zip]) if params[:zip]
    matches = Address.cities_matching(params[:city]) if params[:city]
    matches = Address.street_names_matching(params[:address]) if params[:address]
    render :text => matches.join("\n")
  end

end
