class CreateAgentShips < ActiveRecord::Migration
  def change
    create_table :agentships do |t|
      t.belongs_to :user
      t.belongs_to :agent

      t.timestamps
    end
    add_index :agentships, :user_id
    add_index :agentships, :agent_id
  end
end
