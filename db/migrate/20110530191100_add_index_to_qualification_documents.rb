class AddIndexToQualificationDocuments < ActiveRecord::Migration
  def self.up
    add_index :qualification_documents, [:association_id, :type]
  end

  def self.down
    remove_index :qualification_documents, [:association_id, :type]
  end
end
