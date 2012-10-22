class CreateUsers < ActiveRecord::Migration
  def change
     create_table :users do |t|
       t.string :first_name
       t.string :last_name
       t.string :email
       t.string :location
       t.float :latitude
       t.float :longitude
       t.string :user_about_title
       t.text :user_about
       t.boolean :superadmin
       t.boolean :admin
       t.boolean :editor
       t.timestamps
     end
   end
end
