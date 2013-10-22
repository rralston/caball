class AddFileNameToUploadedDocuments < ActiveRecord::Migration
  def change
    add_column :uploaded_documents, :filename, :string
  end
end
