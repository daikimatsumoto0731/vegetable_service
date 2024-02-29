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

<<<<<<< HEAD
ActiveRecord::Schema[7.0].define(version: 2024_01_28_124932) do
=======
ActiveRecord::Schema[7.0].define(version: 2024_02_26_141057) do
  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vegetable_id"
    t.index ["vegetable_id"], name: "index_events_on_vegetable_id"
  end

  create_table "harvests", force: :cascade do |t|
    t.decimal "amount"
    t.string "vegetable_type"
    t.decimal "price_per_kg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_harvests_on_user_id"
  end

>>>>>>> main
  create_table "line_notification_settings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.boolean "receive_notifications", default: false
    t.string "frequency", default: "daily"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "notification_time"
    t.string "line_auth_info_api_key"
    t.string "line_auth_info_user_id"
    t.index ["user_id"], name: "index_line_notification_settings_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.text "details"
    t.integer "vegetable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vegetable_id"], name: "index_schedules_on_vegetable_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "prefecture"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vegetables", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
<<<<<<< HEAD
  end

=======
    t.date "sowing_date"
  end

  add_foreign_key "harvests", "users"
>>>>>>> main
  add_foreign_key "line_notification_settings", "users"
  add_foreign_key "schedules", "vegetables"
end
