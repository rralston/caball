class Vote < ActiveRecord::Base
  belongs_to :votable, :polymorphic => true
  attr_accessible :is_up_vote, :is_down_vote, :user

  belongs_to :user
end