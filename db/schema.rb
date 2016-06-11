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
    t.integer  "order_id",   limit: 4,                                        null: false
    t.integer  "item_id",    limit: 4,                                        null: false
    t.decimal  "unit_price",           precision: 15, scale: 3, default: 0.0, null: false
    t.integer  "quantity",   limit: 4,                                        null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "order_details", ["order_id"], name: "order_details_order_id_fk", using: :btree

  create_table "orders", force: :cascade do |t|
    t.decimal  "total_price",                   precision: 15, scale: 3, default: 0.0,       null: false
    t.string   "processing_status", limit: 255,                          default: "waiting", null: false
    t.integer  "order_by",          limit: 4,                                                null: false
    t.integer  "assigned_user_id",  limit: 4
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
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