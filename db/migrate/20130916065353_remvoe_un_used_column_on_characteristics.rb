class RemvoeUnUsedColumnOnCharacteristics < ActiveRecord::Migration
  def up
    remove_column :characteristics, :weight
    remove_column :characteristics, :skin_color
    remove_column :characteristics, :eye_color
    remove_column :characteristics, :chest
    remove_column :characteristics, :waist
    remove_column :characteristics, :dress_size
    remove_column :characteristics, :hips

  end

  def down
    add_column :characteristics, :weight, :string
    add_column :characteristics, :skin_color, :string
    add_column :characteristics, :eye_color, :string
    add_column :characteristics, :chest, :string
    add_column :characteristics, :waist, :string
    add_column :characteristics, :dress_size, :string
    add_column :characteristics, :hips, :string
  end
end
