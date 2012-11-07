class DonorsController < ApplicationController
  def index
    @donors = Donor.all
  end

  def new
    @donor = Donor.new
  end

  def create
    @donor = Donor.new(params[:donor])
    if @donor.save
      redirect_to donations_path, :notice => "New donor saved"
    else
      render :new
    end
  end

  def show
    @donor = Donor.find(params[:id])
  end

  def destroy
    @donor = Donor.find(params[:id])
    @donor.destroy
    flash[:info] = "Donor deleted"
    redirect_to donors_path
  end
end
