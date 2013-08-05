class CreateVotesTable < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :is_up_vote, :default => false
      t.boolean :is_down_vote, :default => false
      t.references :user
      t.references :votable, :polymorphic => true
      t.timestamps
    end
  end
end
