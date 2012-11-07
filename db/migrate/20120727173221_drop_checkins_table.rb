class DropCheckinsTable < ActiveRecord::Migration
  def change
    drop_table :checkins
  end
end
