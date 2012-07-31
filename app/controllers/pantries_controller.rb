class PantriesController < ApplicationController
  def index
    @pantries = Pantry.all
  end

  def show
  end

  def new
    @pantry = Pantry.new
  end

  def create
    pantry = Pantry.new(params[:pantry])
    if pantry.save
      redirect_to pantries_path
    end
  end

  def edit
  end

  def update
  end

  def destroy
    pantry = Pantry.find(params[:id])
    pantry.destroy
    redirect_to pantries_path
  end
end
