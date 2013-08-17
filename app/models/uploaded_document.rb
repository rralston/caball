class UploadedDocument < ActiveRecord::Base
  belongs_to :documentable, :polymorphic => true
  attr_accessible :document, :description, :content_type, :file_size, :updated_at
  mount_uploader :document, DocumentUploader
end