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

ActiveRecord::Schema.define(:version => 20121027105355) do

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

  create_table "photos", :force => true do |t|
    t.string   "image"
    t.string   "file_name"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "about"
    t.boolean  "superadmin"
    t.boolean  "admin"
    t.boolean  "editor"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "videos", :force => true do |t|
    t.string   "url"
    t.string   "provider"
    t.string   "title"
    t.text     "description"
    t.string   "keywords"
    t.integer  "duration"
    t.datetime "date"
    t.string   "thumbnail_small"
    t.string   "thumbnail_large"
    t.string   "embed_url"
    t.string   "embed_code"
    t.datetime "video_updated_at"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
