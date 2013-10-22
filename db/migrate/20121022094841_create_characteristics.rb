class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.integer :age
      t.integer :height
      t.integer :weight
      t.string :ethnicity
      t.string :bodytype
      t.string :skin_color
      t.string :eye_color
      t.string :hair_color
      t.integer :chest
      t.integer :waist
      t.integer :hips
      t.integer :dress_size
      t.references :user
      t.timestamps      
    end
  end
end