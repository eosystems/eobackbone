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

ActiveRecord::Schema.define(version: 0) do

  create_table "corporations", primary_key: "corporation_id", force: :cascade do |t|
    t.string   "corporation_name", limit: 255, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "inv_types", force: :cascade do |t|
    t.integer "type_id",         limit: 4,                              null: false
    t.integer "group_id",        limit: 4
    t.string  "type_name",       limit: 255
    t.text    "description",     limit: 65535
    t.float   "mass",            limit: 53
    t.float   "volume",          limit: 53
    t.decimal "base_price",                    precision: 20, scale: 4
    t.integer "market_group_id", limit: 4
  end

  add_index "inv_types", ["type_id"], name: "index_type_id", using: :btree
  add_index "inv_types", ["type_name"], name: "index_type_name", using: :btree

  create_table "map_regions", id: false, force: :cascade do |t|
    t.integer "id",          limit: 4,   null: false
    t.integer "region_id",   limit: 4,   null: false
    t.string  "region_name", limit: 255
  end

  add_index "map_regions", ["region_id"], name: "index_region_id", using: :btree
  add_index "map_regions", ["region_name"], name: "index_region_name", using: :btree

  create_table "map_solar_systems", force: :cascade do |t|
    t.integer "region_id",         limit: 4,   null: false
    t.integer "solar_system_id",   limit: 4,   null: false
    t.string  "solar_system_name", limit: 255, null: false
  end

  add_index "map_solar_systems", ["region_id"], name: "index_region_id", using: :btree
  add_index "map_solar_systems", ["solar_system_id"], name: "index_solar_system_id", using: :btree

  create_table "market_orders", force: :cascade do |t|
    t.integer  "order_id",       limit: 8,                            null: false
    t.integer  "type_id",        limit: 4,                            null: false
    t.boolean  "buy"
    t.datetime "issued"
    t.decimal  "price",                      precision: 20, scale: 4
    t.integer  "volume_entered", limit: 4
    t.integer  "station_id",     limit: 4
    t.integer  "volume",         limit: 4
    t.string   "range",          limit: 255
    t.integer  "min_volume",     limit: 4
    t.integer  "duration",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "market_orders", ["type_id", "buy", "station_id"], name: "index_type_id_and_buy_and_station_id", using: :btree

  create_table "order_details", force: :cascade do |t|
    t.integer  "order_id",        limit: 4,                                        null: false
    t.integer  "item_id",         limit: 4,                                        null: false
    t.decimal  "unit_price",                precision: 20, scale: 4, default: 0.0, null: false
    t.decimal  "sell_unit_price",           precision: 20, scale: 4, default: 0.0, null: false
    t.integer  "quantity",        limit: 4,                                        null: false
    t.decimal  "volume",                    precision: 20, scale: 4, default: 0.0, null: false
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "order_details", ["order_id"], name: "order_details_order_id_fk", using: :btree

  create_table "orders", force: :cascade do |t|
    t.decimal  "total_price",                     precision: 20, scale: 4, default: 0.0,          null: false
    t.decimal  "sell_price",                      precision: 20, scale: 4, default: 0.0,          null: false
    t.decimal  "total_volume",                    precision: 20, scale: 4, default: 0.0,          null: false
    t.boolean  "is_credit",                                                default: false,        null: false
    t.string   "processing_status", limit: 255,                            default: "in_process", null: false
    t.integer  "station_id",        limit: 4
    t.integer  "order_by",          limit: 4,                                                     null: false
    t.integer  "assigned_user_id",  limit: 4
    t.integer  "corporation_id",    limit: 4
    t.text     "note",              limit: 65535
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
  end

  create_table "sta_stations", force: :cascade do |t|
    t.integer "station_id",      limit: 4,   null: false
    t.integer "region_id",       limit: 4,   null: false
    t.integer "solar_system_id", limit: 4,   null: false
    t.string  "station_name",    limit: 255, null: false
  end

  add_index "sta_stations", ["solar_system_id"], name: "index_solar_system_id", using: :btree
  add_index "sta_stations", ["station_id"], name: "index_station_id", using: :btree

  create_table "user_details", force: :cascade do |t|
    t.integer "user_id",           limit: 4,   null: false
    t.integer "corporation_id",    limit: 4
    t.integer "alliance_id",       limit: 4
    t.string  "key_id",            limit: 255
    t.string  "verification_code", limit: 255
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "role",    limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "uid",                    limit: 255,              null: false
    t.string   "name",                   limit: 255
    t.string   "token",                  limit: 255
    t.string   "refresh_token",          limit: 255
    t.datetime "expire"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "provider",               limit: 255,              null: false
    t.string   "email",                  limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255, default: ""
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255, default: "", null: false
    t.string   "last_sign_in_ip",        limit: 255, default: "", null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_foreign_key "order_details", "orders", name: "order_details_order_id_fk"
end
