class CreateTypes < ActiveRecord::Migration
    def change
      create_table :type do |t|
        t.string :name
        t.text :description
        t.references :user
        t.timestamps
    end
  end
end
