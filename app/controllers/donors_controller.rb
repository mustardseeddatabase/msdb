class DonorsController < ApplicationController
  def new
    @donor = Donor.new
  end

  def create
    @donor = Donor.create(params[:donor])
    redirect_to donations_path, :notice => "New donor saved"
  end
end
