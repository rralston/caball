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

ActiveRecord::Schema.define(:version => 20130725090518) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "attends", :force => true do |t|
    t.integer  "attendable_id"
    t.string   "attendable_type"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "attends", ["user_id", "attendable_id"], :name => "index_attends_on_user_id_and_attendable_id"

  create_table "blogs", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blogs", ["user_id"], :name => "index_blogs_on_user_id"

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

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "endorsements", :force => true do |t|
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.text     "message"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "endorsements", ["receiver_id", "sender_id"], :name => "index_endorsements_on_receiver_id_and_sender_id"

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "website"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "important_dates", :force => true do |t|
    t.integer  "important_dateable_id"
    t.string   "important_dateable_type"
    t.string   "description"
    t.string   "date_time"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "is_start_date",           :default => false
    t.boolean  "is_end_date",             :default => false
  end

  add_index "important_dates", ["important_dateable_id"], :name => "index_important_dates_on_important_dateable_id"

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "loveable_id"
    t.string   "loveable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
  end

  add_index "notifications", ["conversation_id"], :name => "index_notifications_on_conversation_id"

  create_table "photos", :force => true do |t|
    t.string   "image"
    t.text     "description"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "updated_at",                        :null => false
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",                        :null => false
    t.boolean  "primary"
    t.boolean  "is_main",        :default => false
    t.boolean  "is_cover",       :default => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "image"
    t.string   "description"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "status"
    t.boolean  "featured"
    t.string   "is_type"
    t.string   "genre"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "thoughts"
    t.string   "compensation"
    t.text     "headline"
    t.string   "union"
  end

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "resumes", :force => true do |t|
    t.string   "document"
    t.string   "description"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "updated_at",        :null => false
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at",        :null => false
  end

  create_table "role_applications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.text     "message"
    t.boolean  "approved",   :default => false
  end

  add_index "role_applications", ["user_id", "role_id"], :name => "index_role_applications_on_user_id_and_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "filled",      :default => false
    t.string   "subrole"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "talents", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "description2"
    t.string   "experience"
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
    t.string   "gender"
    t.string   "imdb_url"
    t.text     "headline"
    t.boolean  "featured"
    t.string   "expertise"
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
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "user_description"
    t.string   "imdb"
    t.boolean  "primary"
  end

  create_table "votes", :force => true do |t|
    t.boolean  "is_up_vote",   :default => false
    t.boolean  "is_down_vote", :default => false
    t.integer  "user_id"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_foreign_key "notifications", "conversations", :name => "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", :name => "receipts_on_notification_id"

end
