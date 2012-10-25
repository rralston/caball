# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121022094841) do

  create_table "characteristics", :force => true do |t|
    t.integer  "age"
    t.integer  "height"
    t.integer  "weight"
    t.string   "ethnicity"
    t.string   "bodytype"
    t.string   "skin_color"
    t.string   "eye_color"
    t.string   "hair_color"
    t.integer  "chest"
    t.integer  "waist"
    t.integer  "hips"
    t.integer  "dress_size"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "about"
    t.boolean  "superadmin"
    t.boolean  "admin"
    t.boolean  "editor"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
