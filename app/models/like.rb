class Like < ActiveRecord::Base
  attr_accessible :loveable_id, :loveable_type
  belongs_to :user
  belongs_to :loveable, :polymorphic => true
end
