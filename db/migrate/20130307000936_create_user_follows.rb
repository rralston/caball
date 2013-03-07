class CreateUserFollows < ActiveRecord::Migration
  def change
      create_table :follows do |t|
        t.belongs_to :user
        t.belongs_to :follow
        t.timestamps
      end
      add_index :follows, :user_id
      add_index :follows, :follow_id
  end
end