class AddDocfileColumnToQualificationDocuments < ActiveRecord::Migration
  def self.up
    add_column :qualification_documents, :docfile, :string
  end

  def self.down
    remove_column :qualification_documents, :docfile
  end
end
