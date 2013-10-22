class CreateResumeTable < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.string :document
      t.string :description
      t.string :content_type
      t.integer :file_size
      t.datetime :updated_at
      t.references :documentable, :polymorphic => true
      t.timestamps
    end
  end
end
