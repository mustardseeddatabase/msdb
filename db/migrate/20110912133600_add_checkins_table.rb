class AddCheckinsTable < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :client_id
      t.integer :parent_id
      t.boolean :id_warn, :default => false
      t.boolean :inc_warn, :default => false
      t.boolean :res_warn, :default => false
      t.boolean :gov_warn, :default => false
      t.timestamps
    end
    add_index :checkins, :client_id
    add_index :checkins, :parent_id
  end
end
