class CreateUsers < ActiveRecord::Migration
  def change
     create_table :users do |t|
       t.string :name
       t.string :email
       t.string :location
       t.float :latitude
       t.float :longitude
       t.text :about
       t.boolean :superadmin
       t.boolean :admin
       t.boolean :editor
       t.string :provider
       t.string :uid
       t.string :oauth_token
       t.datetime :oauth_expires_at
       t.timestamps
     end
   end
end
