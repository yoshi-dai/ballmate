# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_05_13_042359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_requests", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.bigint "matching_id", null: false
    t.integer "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["matching_id"], name: "index_chat_requests_on_matching_id"
    t.index ["receiver_id"], name: "index_chat_requests_on_receiver_id"
    t.index ["sender_id"], name: "index_chat_requests_on_sender_id"
  end

  create_table "favorite_soccer_activities", force: :cascade do |t|
    t.string "soccer_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "group_users", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_users_on_group_id"
    t.index ["user_id"], name: "index_group_users_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "matching_profiles", force: :cascade do |t|
    t.bigint "matching_id", null: false
    t.string "activity_content"
    t.string "activity_detail"
    t.string "recruitment_content"
    t.string "short_message"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["matching_id"], name: "index_matching_profiles_on_matching_id"
  end

  create_table "matching_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "matching_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["matching_id"], name: "index_matching_users_on_matching_id"
    t.index ["user_id"], name: "index_matching_users_on_user_id"
  end

  create_table "matchings", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "time_zone"
    t.string "place"
    t.boolean "public_flag"
    t.string "weather_code"
    t.decimal "temperature"
    t.string "weather_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "matching_id", null: false
    t.bigint "user_id", null: false
    t.string "type"
    t.text "text"
    t.string "image_url"
    t.integer "sticker_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["matching_id"], name: "index_messages_on_matching_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "matching_id", null: false
    t.string "title"
    t.text "content"
    t.boolean "read"
    t.datetime "read_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["matching_id"], name: "index_notifications_on_matching_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "profile_soccer_activities", force: :cascade do |t|
    t.bigint "user_profile_id", null: false
    t.bigint "favorite_soccer_activity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["favorite_soccer_activity_id"], name: "index_profile_soccer_activities_on_favorite_soccer_activity_id"
    t.index ["user_profile_id"], name: "index_profile_soccer_activities_on_user_profile_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "favorite_player"
    t.string "position"
    t.string "role_in_team"
    t.string "image"
    t.integer "age"
    t.string "favorite_place"
    t.string "active_area"
    t.string "equipment"
    t.string "available_day_of_week"
    t.string "available_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "image_cache"
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "chat_requests", "matchings"
  add_foreign_key "chat_requests", "users", column: "receiver_id"
  add_foreign_key "chat_requests", "users", column: "sender_id"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "matching_profiles", "matchings"
  add_foreign_key "matching_users", "matchings"
  add_foreign_key "matching_users", "users"
  add_foreign_key "messages", "matchings"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "matchings"
  add_foreign_key "notifications", "users"
  add_foreign_key "profile_soccer_activities", "favorite_soccer_activities"
  add_foreign_key "profile_soccer_activities", "user_profiles"
  add_foreign_key "user_profiles", "users"
end
