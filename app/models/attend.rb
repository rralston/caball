class Attend < ActiveRecord::Base
  belongs_to :attendable, :polymorphic => true
  belongs_to :user
  
  attr_accessible :user, :attendable
end