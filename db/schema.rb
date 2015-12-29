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

ActiveRecord::Schema.define(version: 20151229211040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_statuses", force: true do |t|
    t.boolean  "active"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "downloads", force: true do |t|
    t.integer  "export_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exports", force: true do |t|
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
  end

  create_table "maps", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", force: true do |t|
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
