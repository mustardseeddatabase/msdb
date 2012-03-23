class CreateQualificationDocuments < ActiveRecord::Migration
  def self.up
    create_table :qualification_documents do |t|
      t.string :type
      t.integer :association_id
      t.boolean :confirm
      t.date :date
      t.integer :warnings
      t.boolean :vi
      t.timestamps
    end
  end

  def self.down
    drop_table :qualification_documents
  end
end
