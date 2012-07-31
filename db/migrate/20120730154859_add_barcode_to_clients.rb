class AddBarcodeToClients < ActiveRecord::Migration
  def change
    add_column :clients, :barcode, :text
  end
end
