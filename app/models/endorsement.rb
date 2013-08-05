class Endorsement < ActiveRecord::Base
  
  attr_accessible :message, :receiver_id, :sender_id

  include PublicActivity::Model
  tracked except: :destroy

  belongs_to :receiver, :class_name => "User"
  belongs_to :sender, :class_name => "User"

  def serializable_hash(options)
    hash = super(options)
    extra_hash = {
      'receiver' => receiver,
      'sender'   => sender
    }
    hash.merge!(extra_hash)
  end

end