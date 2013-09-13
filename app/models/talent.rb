class Talent < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :description, :experience, :script_document_attributes,
                  :script_document, :synopsis, :sub_talent, :super_sub_talent

  # this is used only in the case when the user selects writer as his role.
  has_one :script_document, :class_name => 'UploadedDocument', :as => :documentable, :dependent => :destroy

  accepts_nested_attributes_for :script_document, :allow_destroy => true
  
end