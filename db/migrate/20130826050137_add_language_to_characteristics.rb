class AddLanguageToCharacteristics < ActiveRecord::Migration
  def change
    add_column :characteristics, :language, :string
  end
end
