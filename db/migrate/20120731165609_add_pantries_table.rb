class AddPantriesTable < ActiveRecord::Migration
  def change
    create_table :pantries do |t|
      t.string :name
      t.integer :id
      t.timestamps
    end

    add_column :distributions, :pantry_id, :integer
    add_column :users, :pantry_id, :integer
  end
end
