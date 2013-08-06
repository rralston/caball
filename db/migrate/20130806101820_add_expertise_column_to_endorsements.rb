class AddExpertiseColumnToEndorsements < ActiveRecord::Migration
  def change
    add_column :endorsements, :expertise, :string
  end
end
