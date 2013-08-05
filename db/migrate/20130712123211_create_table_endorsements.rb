class CreateTableEndorsements < ActiveRecord::Migration
  def change
    create_table :endorsements do |t|
      t.references :receiver
      t.references :sender

      t.text :message

      t.timestamps
    end
    add_index :endorsements, [:receiver_id, :sender_id]
  end
end
