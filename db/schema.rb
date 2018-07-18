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

ActiveRecord::Schema.define(version: 20170920050406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_statuses", id: :serial, force: :cascade do |t|
    t.boolean "active"
    t.text "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", id: :serial, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bounds", id: :serial, force: :cascade do |t|
    t.string "sw_lat"
    t.string "sw_lng"
    t.string "ne_lat"
    t.string "ne_lng"
    t.integer "search_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["search_id"], name: "index_bounds_on_search_id"
  end

  create_table "downloads", id: :serial, force: :cascade do |t|
    t.integer "export_id"
    t.string "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exports", id: :serial, force: :cascade do |t|
    t.text "sites"
    t.string "uuid"
    t.date "starts_at"
    t.date "ends_at"
    t.string "email"
    t.integer "user_id"
    t.string "timestep"
    t.text "variables"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status", default: "queued"
    t.integer "progress", default: 0
    t.text "message"
    t.integer "search_id"
    t.index ["search_id"], name: "index_exports_on_search_id"
  end

  create_table "maps", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "q"
    t.string "siteids"
    t.string "networkcode"
    t.string "organizationcode"
    t.string "datatype"
    t.string "samplemedium"
    t.string "generalcategory"
    t.string "valuetype"
    t.string "variablename"
    t.string "derived_values"
    t.string "time_step"
  end

  create_table "site_exports", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "search_id"
    t.string "status"
    t.string "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["search_id"], name: "index_site_exports_on_search_id"
    t.index ["user_id"], name: "index_site_exports_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
  end

  add_foreign_key "bounds", "searches"
  add_foreign_key "exports", "searches"
  add_foreign_key "site_exports", "searches"
  add_foreign_key "site_exports", "users"
end
