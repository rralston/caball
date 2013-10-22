class ChangeAgeToStringFromInteger < ActiveRecord::Migration
  def up
    change_column :characteristics, :age, :string
  end

  def down
    change_column :characteristics, :age, :integer
  end
end
