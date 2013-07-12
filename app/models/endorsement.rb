class Endorsement < ActiveRecord::Base
  
  belongs_to :receiver, :class_name => "User"
  belongs_to :sender, :class_name => "User"

  attr_accessible :message, :receiver_id, :sender_id

end