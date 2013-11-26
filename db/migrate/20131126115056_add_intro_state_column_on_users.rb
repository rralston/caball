class AddIntroStateColumnOnUsers < ActiveRecord::Migration
  def change
    add_column :users, :finished_intro_state, :integer, :default => 0
  end
end
