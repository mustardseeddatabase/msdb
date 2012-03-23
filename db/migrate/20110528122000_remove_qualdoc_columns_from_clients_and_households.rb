class RemoveQualdocColumnsFromClientsAndHouseholds < ActiveRecord::Migration
  def self.up
    remove_column :households, :resConfirm, :resDate, :resWarn, :resVi, :incConfirm, :incDate, :incWarn, :incVi, :govConfirm, :govDate, :govWarn, :govVi
    remove_column :clients, :idConfirm, :idDate, :idWarn, :idVi
  end

  def self.down
    add_column :households, :resConfirm, :boolean
    add_column :households, :resDate, :datetime
    add_column :households, :resWarn, :integer
    add_column :households, :resVi, :boolean
    add_column :households, :incConfirm, :boolean
    add_column :households, :incDate, :datetime
    add_column :households, :incWarn, :integer
    add_column :households, :incVi, :boolean
    add_column :households, :govConfirm, :boolean
    add_column :households, :govDate, :datetime
    add_column :households, :govWarn, :integer
    add_column :households, :govVi, :boolean
    add_column :clients, :idConfirm, :boolean
    add_column :clients, :idDate, :datetime
    add_column :clients, :idWarn, :integer
    add_column :clients, :idVi, :boolean
  end
end
