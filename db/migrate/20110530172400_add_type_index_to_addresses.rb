class AddTypeIndexToAddresses < ActiveRecord::Migration
  def self.up
    add_index :addresses, [:id, :type]
  end

  def self.down
    remove_index :qualification_documents, [:id, :type]
  end
end
