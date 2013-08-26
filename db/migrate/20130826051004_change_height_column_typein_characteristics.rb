class ChangeHeightColumnTypeinCharacteristics < ActiveRecord::Migration
  def up
    change_column :characteristics, :height, :string
  end

  def down
    change_column :characteristics, :height, :integer
  end
end
