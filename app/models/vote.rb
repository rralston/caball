class Vote < ActiveRecord::Base
  belongs_to :votable, :polymorphic => true
  attr_accessible :is_up_vote, :is_down_vote, :user, :value

  belongs_to :user


  before_save :update_value

  # update_value based on the vote type
  def update_value
    if self.is_up_vote
      self.value = 1
    else
      self.value = -1
    end
  end
end