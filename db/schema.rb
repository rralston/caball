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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140220230555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "agentships", force: true do |t|
    t.integer  "user_id"
    t.integer  "agent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "agentships", ["agent_id"], name: "index_agentships_on_agent_id", using: :btree
  add_index "agentships", ["user_id"], name: "index_agentships_on_user_id", using: :btree

  create_table "attends", force: true do |t|
    t.integer  "attendable_id"
    t.string   "attendable_type"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "attends", ["user_id", "attendable_id"], name: "index_attends_on_user_id_and_attendable_id", using: :btree

  create_table "blogs", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blogs", ["user_id"], name: "index_blogs_on_user_id", using: :btree

  create_table "characteristics", force: true do |t|
    t.string   "age"
    t.string   "height"
    t.string   "ethnicity"
    t.string   "bodytype"
    t.string   "hair_color"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "language"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "credit_cards", force: true do |t|
    t.integer  "user_id"
    t.string   "card_type"
    t.string   "card_token"
    t.string   "last_four_digits"
    t.string   "uri"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "endorsements", force: true do |t|
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.text     "message"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "expertise"
  end

  add_index "endorsements", ["receiver_id", "sender_id"], name: "index_endorsements_on_receiver_id_and_sender_id", using: :btree

  create_table "events", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "website"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "url_name"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "features", force: true do |t|
    t.string   "key",                        null: false
    t.boolean  "enabled",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "follows", force: true do |t|
    t.integer  "user_id"
    t.integer  "follow_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "follows", ["follow_id"], name: "index_follows_on_follow_id", using: :btree
  add_index "follows", ["user_id"], name: "index_follows_on_user_id", using: :btree

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "important_dates", force: true do |t|
    t.integer  "important_dateable_id"
    t.string   "important_dateable_type"
    t.string   "description"
    t.string   "date_time"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "is_start_date",           default: false
    t.boolean  "is_end_date",             default: false
    t.string   "date"
    t.string   "time_string"
  end

  add_index "important_dates", ["important_dateable_id"], name: "index_important_dates_on_important_dateable_id", using: :btree

  create_table "likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "loveable_id"
    t.string   "loveable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
  end

  add_index "notifications", ["conversation_id"], name: "index_notifications_on_conversation_id", using: :btree

  create_table "photos", force: true do |t|
    t.string   "image"
    t.text     "description"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "updated_at",                      null: false
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",                      null: false
    t.boolean  "primary"
    t.boolean  "is_main",         default: false
    t.boolean  "is_cover",        default: false
    t.integer  "crop_x"
    t.integer  "crop_y"
    t.integer  "crop_w"
    t.integer  "crop_h"
    t.integer  "original_width"
    t.integer  "original_height"
  end

  create_table "profiles", force: true do |t|
    t.string   "image"
    t.string   "description"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.integer  "crop_x"
    t.integer  "crop_y"
    t.integer  "crop_w"
    t.integer  "crop_h"
    t.integer  "original_width"
    t.integer  "original_height"
  end

  create_table "projects", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "status"
    t.boolean  "featured"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "thoughts"
    t.string   "compensation"
    t.text     "headline"
    t.string   "union"
    t.string   "url_name"
    t.boolean  "union_present", default: false
  end

  create_table "receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "receipts", ["notification_id"], name: "index_receipts_on_notification_id", using: :btree

  create_table "role_applications", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "message"
    t.boolean  "approved",   default: false
    t.boolean  "manager",    default: false
  end

  add_index "role_applications", ["user_id", "role_id"], name: "index_role_applications_on_user_id_and_role_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "filled",        default: false
    t.string   "subrole"
    t.string   "gender",        default: "male"
    t.string   "super_subrole"
    t.string   "age"
    t.string   "ethnicity"
    t.string   "height"
    t.string   "build"
    t.string   "haircolor"
    t.string   "cast_title"
  end

  create_table "search_suggestions", force: true do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "talents", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "synopsis"
    t.string   "sub_talent"
    t.string   "super_sub_talent"
  end

  create_table "updates", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "updates", ["project_id"], name: "index_updates_on_project_id", using: :btree
  add_index "updates", ["user_id"], name: "index_updates_on_user_id", using: :btree

  create_table "uploaded_documents", force: true do |t|
    t.string   "document"
    t.string   "description"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "updated_at",        null: false
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at",        null: false
    t.string   "filename"
  end

  create_table "urls", force: true do |t|
    t.string   "url"
    t.integer  "urlable_id"
    t.string   "urlable_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "gender"
    t.string   "imdb_url"
    t.text     "headline"
    t.boolean  "featured"
    t.string   "expertise"
    t.datetime "notification_check_time", default: '2013-08-06 22:13:33'
    t.string   "experience"
    t.boolean  "agent_present",           default: false
    t.string   "agent_name"
    t.string   "guild"
    t.boolean  "guild_present",           default: false
    t.string   "url_name"
    t.string   "encrypted_password",      default: "",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "fb_token"
    t.string   "managing_company"
    t.boolean  "send_notification_mails", default: true
    t.integer  "finished_intro_state",    default: 0
    t.string   "ssn_last4"
    t.string   "bp_id"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: true do |t|
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
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "user_description"
    t.string   "imdb"
    t.boolean  "primary"
    t.boolean  "is_demo_reel",     default: false
  end

  create_table "votes", force: true do |t|
    t.boolean  "is_up_vote",   default: false
    t.boolean  "is_down_vote", default: false
    t.integer  "user_id"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "value",        default: 0
  end

  add_foreign_key "notifications", "conversations", name: "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", name: "receipts_on_notification_id"

end
