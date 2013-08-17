class Agentship < ActiveRecord::Base
  belongs_to :user
  belongs_to :agent, class_name: "User"

  attr_accessible :agent_id
end
