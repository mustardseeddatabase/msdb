class ScannerController < ApplicationController
  def index
  end

  def show
    if request.xhr?
      barcode = params[:barcode]
      item = Item.find_by_upc(barcode)
      if item.blank?
        render :partial => 'not_found', :locals => {:barcode => barcode}
      else
        render :partial => 'item', :locals => {:item => item}
      end
    end
  end
end
