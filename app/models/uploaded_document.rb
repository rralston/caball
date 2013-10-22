class UploadedDocument < ActiveRecord::Base
  belongs_to :documentable, :polymorphic => true
  
  attr_accessor :_destroy
  attr_accessible :_destroy

  attr_accessible :document, :description, :content_type, :file_size, :updated_at, :filename
  mount_uploader :document, DocumentUploader

  before_save :save_file_name, :if => :document_present?

  def document_present?
    document.present?
  end

  def save_file_name
    if document_changed?
      self.filename = document.filename
    end
  end

end