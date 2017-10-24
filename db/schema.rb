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

ActiveRecord::Schema.define(version: 20170920050406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_statuses", force: :cascade do |t|
    t.boolean  "active"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bounds", force: :cascade do |t|
    t.string   "sw_lat"
    t.string   "sw_lng"
    t.string   "ne_lat"
    t.string   "ne_lng"
    t.integer  "search_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bounds", ["search_id"], name: "index_bounds_on_search_id", using: :btree

  create_table "downloads", force: :cascade do |t|
    t.integer  "export_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exports", force: :cascade do |t|
    t.text     "sites"
    t.string   "uuid"
    t.date     "starts_at"
    t.date     "ends_at"
    t.string   "email"
    t.integer  "user_id"
    t.string   "timestep"
    t.text     "variables"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     default: "queued"
    t.integer  "progress",   default: 0
    t.text     "message"
    t.integer  "search_id"
  end

  add_index "exports", ["search_id"], name: "index_exports_on_search_id", using: :btree

  create_table "maps", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "q"
    t.string   "siteids"
    t.string   "networkcode"
    t.string   "organizationcode"
    t.string   "datatype"
    t.string   "samplemedium"
    t.string   "generalcategory"
    t.string   "valuetype"
    t.string   "variablename"
    t.string   "derived_values"
    t.string   "time_step"
  end

  create_table "site_exports", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "search_id"
    t.string   "status"
    t.string   "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "site_exports", ["search_id"], name: "index_site_exports_on_search_id", using: :btree
  add_index "site_exports", ["user_id"], name: "index_site_exports_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "avatar"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "admin",      default: false
  end

  add_foreign_key "bounds", "searches"
  add_foreign_key "exports", "searches"
  add_foreign_key "site_exports", "searches"
  add_foreign_key "site_exports", "users"
end
