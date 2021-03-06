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

  create_table "api_managements", force: :cascade do |t|
    t.string   "key_id",                    limit: 255, null: false
    t.string   "v_code",                    limit: 255, null: false
    t.string   "uid",                       limit: 255, null: false
    t.string   "character_id",              limit: 255, null: false
    t.string   "character_name",            limit: 255, null: false
    t.string   "corporation_id",            limit: 255, null: false
    t.string   "alliance_id",               limit: 255
    t.integer  "access_mask",               limit: 8,   null: false
    t.boolean  "alpha",                                 null: false
    t.boolean  "full_api",                              null: false
    t.datetime "expires"
    t.string   "api_manage_corporation_id", limit: 255, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "application_member_relations", force: :cascade do |t|
    t.integer  "character_id",        limit: 4
    t.string   "character_name",      limit: 255
    t.integer  "main_character_id",   limit: 4
    t.string   "main_character_name", limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "application_new_members", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", force: :cascade do |t|
    t.string   "targetable_type",   limit: 255,                        null: false
    t.integer  "targetable_id",     limit: 4,                          null: false
    t.string   "processing_status", limit: 255, default: "in_process", null: false
    t.integer  "process_user_id",   limit: 4
    t.integer  "corporation_id",    limit: 4
    t.integer  "user_id",           limit: 4
    t.datetime "done_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", force: :cascade do |t|
    t.string   "audit_type",     limit: 255,   null: false
    t.text     "audit_text",     limit: 65535, null: false
    t.string   "uid",            limit: 255,   null: false
    t.string   "corporation_id", limit: 255,   null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "corp_api_managements", force: :cascade do |t|
    t.string   "key_id",         limit: 255, null: false
    t.string   "v_code",         limit: 255, null: false
    t.string   "corporation_id", limit: 255, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "corp_members", force: :cascade do |t|
    t.integer  "character_id",            limit: 4
    t.string   "character_name",          limit: 255
    t.integer  "main_character_id",       limit: 4
    t.string   "main_character_name",     limit: 255
    t.boolean  "is_main"
    t.integer  "corporation_id",          limit: 4
    t.string   "corporation_name",        limit: 255
    t.integer  "manage_corporation_id",   limit: 4
    t.string   "manage_corporation_name", limit: 255
    t.string   "corp_role",               limit: 255
    t.boolean  "token_verify",                        default: false, null: false
    t.boolean  "token_error",                         default: false, null: false
    t.datetime "entry_date"
    t.datetime "character_birthday"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "corp_wallet_divisions", force: :cascade do |t|
    t.integer  "account_key",    limit: 4,   null: false
    t.string   "name",           limit: 255, null: false
    t.string   "corporation_id", limit: 255, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "corp_wallet_journals", force: :cascade do |t|
    t.datetime "i_date",                                                                       null: false
    t.integer  "ref_id",                  limit: 8,                                            null: false
    t.integer  "ref_type_id",             limit: 4
    t.string   "owner_name1",             limit: 255
    t.integer  "owner_id1",               limit: 8
    t.string   "owner_name2",             limit: 255
    t.integer  "owner_id2",               limit: 8
    t.string   "arg_name1",               limit: 255
    t.integer  "arg_id_1",                limit: 4
    t.decimal  "amount",                              precision: 20, scale: 4, default: 0.0,   null: false
    t.decimal  "balance",                             precision: 20, scale: 4, default: 0.0,   null: false
    t.string   "reason",                  limit: 255
    t.integer  "owner1_type_id",          limit: 4
    t.integer  "owner2_type_id",          limit: 4
    t.string   "corporation_id",          limit: 255,                                          null: false
    t.integer  "corp_wallet_division_id", limit: 4,                                            null: false
    t.integer  "mod_status",              limit: 4
    t.boolean  "ignore",                                                       default: false, null: false
    t.integer  "mod_ref_type_id",         limit: 4
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
  end

  add_index "corp_wallet_journals", ["ref_id"], name: "index_corp_wallet_journals_on_ref_id", using: :btree

  create_table "corporation_relations", force: :cascade do |t|
    t.integer  "ancestor",    limit: 4,                 null: false
    t.integer  "descendant",  limit: 4,                 null: false
    t.boolean  "only_parent",           default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "corporation_relations", ["ancestor"], name: "index_corporation_relations_on_ancestor", using: :btree
  add_index "corporation_relations", ["descendant"], name: "index_corporation_relations_on_descendant", using: :btree

  create_table "corporations", primary_key: "corporation_id", force: :cascade do |t|
    t.string   "corporation_name", limit: 255, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.text     "iframe_text",    limit: 65535
    t.string   "title",          limit: 255
    t.string   "description",    limit: 255
    t.integer  "corporation_id", limit: 4
    t.integer  "user_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "departments", force: :cascade do |t|
    t.string   "department_name", limit: 255,                 null: false
    t.boolean  "delete_flag",                 default: false, null: false
    t.integer  "corporation_id",  limit: 4
    t.integer  "buy_percentage",  limit: 4,   default: 90,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "station_id",     limit: 8
    t.integer  "volume",         limit: 4
    t.string   "range",          limit: 255
    t.integer  "min_volume",     limit: 4
    t.integer  "duration",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "market_orders", ["type_id", "buy", "station_id"], name: "index_type_id_and_buy_and_station_id", using: :btree

  create_table "monitor_market_orders", force: :cascade do |t|
    t.integer  "order_id",       limit: 8,                            null: false
    t.integer  "type_id",        limit: 4,                            null: false
    t.boolean  "buy"
    t.datetime "issued"
    t.decimal  "price",                      precision: 20, scale: 4
    t.integer  "volume_entered", limit: 4
    t.integer  "station_id",     limit: 8
    t.integer  "volume",         limit: 4
    t.string   "range",          limit: 255
    t.integer  "min_volume",     limit: 4
    t.integer  "duration",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monitor_market_orders", ["type_id", "buy", "station_id"], name: "index_type_id_and_buy_and_station_id", using: :btree

  create_table "order_details", force: :cascade do |t|
    t.integer  "order_id",            limit: 4,                                        null: false
    t.integer  "item_id",             limit: 4,                                        null: false
    t.decimal  "unit_price",                    precision: 20, scale: 4, default: 0.0, null: false
    t.decimal  "sell_unit_price",               precision: 20, scale: 4, default: 0.0, null: false
    t.decimal  "buy_unit_price",                precision: 20, scale: 4, default: 0.0, null: false
    t.integer  "quantity",            limit: 4,                                        null: false
    t.decimal  "volume",                        precision: 20, scale: 4, default: 0.0, null: false
    t.decimal  "pre_sell_unit_price",           precision: 20, scale: 4, default: 0.0, null: false
    t.decimal  "pre_buy_unit_price",            precision: 20, scale: 4, default: 0.0, null: false
    t.integer  "pre_quantity",        limit: 4,                          default: 0,   null: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
  end

  add_index "order_details", ["order_id"], name: "order_details_order_id_fk", using: :btree

  create_table "orders", force: :cascade do |t|
    t.decimal  "total_price",                             precision: 20, scale: 4, default: 0.0,          null: false
    t.decimal  "total_jita_sell_price",                   precision: 20, scale: 4, default: 0.0,          null: false
    t.decimal  "sell_price",                              precision: 20, scale: 4, default: 0.0,          null: false
    t.decimal  "total_volume",                            precision: 20, scale: 4, default: 0.0,          null: false
    t.boolean  "is_credit",                                                        default: false,        null: false
    t.boolean  "is_paid",                                                          default: false,        null: false
    t.string   "processing_status",         limit: 255,                            default: "in_process", null: false
    t.integer  "station_id",                limit: 8
    t.integer  "order_by",                  limit: 4,                                                     null: false
    t.integer  "assigned_user_id",          limit: 4
    t.integer  "corporation_id",            limit: 4
    t.text     "note",                      limit: 65535
    t.integer  "department_id",             limit: 4
    t.boolean  "is_buy",                                                           default: false,        null: false
    t.decimal  "total_estimate_sell_price",               precision: 20, scale: 4, default: 0.0,          null: false
    t.decimal  "total_estimate_buy_price",                precision: 20, scale: 4, default: 0.0,          null: false
    t.datetime "done_date"
    t.datetime "estimate_date"
    t.datetime "created_at",                                                                              null: false
    t.datetime "updated_at",                                                                              null: false
  end

  create_table "ref_types", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "ref_types", ["name"], name: "index_name", using: :btree

  create_table "sta_stations", force: :cascade do |t|
    t.integer "station_id",      limit: 8,   null: false
    t.integer "region_id",       limit: 4,   null: false
    t.integer "solar_system_id", limit: 4,   null: false
    t.string  "station_name",    limit: 255, null: false
  end

  add_index "sta_stations", ["solar_system_id"], name: "index_solar_system_id", using: :btree
  add_index "sta_stations", ["station_id"], name: "index_station_id", using: :btree

  create_table "systems", force: :cascade do |t|
    t.boolean  "flag",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trade_details", force: :cascade do |t|
    t.integer  "trade_id",             limit: 4, null: false
    t.integer  "user_market_order_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trade_details", ["trade_id"], name: "trade_details_trade_id_fk", using: :btree

  create_table "trades", force: :cascade do |t|
    t.datetime "trade_date"
    t.integer  "type_id",                limit: 4,                                          null: false
    t.integer  "user_id",                limit: 4,                                          null: false
    t.integer  "sales_quantity",         limit: 4,                          default: 0,     null: false
    t.integer  "sales_average_price",    limit: 4,                          default: 0,     null: false
    t.integer  "purchase_quantity",      limit: 4,                          default: 0,     null: false
    t.integer  "purchase_average_price", limit: 4,                          default: 0,     null: false
    t.decimal  "sales",                            precision: 20, scale: 4, default: 0.0
    t.decimal  "cost",                             precision: 20, scale: 4, default: 0.0
    t.decimal  "tax",                              precision: 20, scale: 4, default: 0.0
    t.decimal  "expense",                          precision: 20, scale: 4, default: 0.0
    t.decimal  "profit",                           precision: 20, scale: 4, default: 0.0
    t.decimal  "inventory_valuation",              precision: 20, scale: 4, default: 0.0
    t.boolean  "summary",                                                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trn_translations", force: :cascade do |t|
    t.string  "tc_id",       limit: 255
    t.integer "key_id",      limit: 4
    t.string  "language_id", limit: 255
    t.text    "text",        limit: 65535
  end

  create_table "user_details", force: :cascade do |t|
    t.integer "user_id",           limit: 4,   null: false
    t.integer "corporation_id",    limit: 4
    t.integer "alliance_id",       limit: 4
    t.string  "key_id",            limit: 255
    t.string  "verification_code", limit: 255
  end

  create_table "user_market_orders", force: :cascade do |t|
    t.integer  "order_id",       limit: 8,                            null: false
    t.integer  "user_id",        limit: 4,                            null: false
    t.integer  "station_id",     limit: 8
    t.integer  "volume_entered", limit: 4
    t.integer  "volume_remain",  limit: 4
    t.integer  "min_volume",     limit: 4
    t.integer  "order_state",    limit: 4
    t.integer  "type_id",        limit: 4,                            null: false
    t.string   "range",          limit: 255
    t.string   "account_key",    limit: 255
    t.integer  "duration",       limit: 4
    t.decimal  "price",                      precision: 20, scale: 4
    t.boolean  "buy"
    t.datetime "issued"
    t.boolean  "monitor"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "wallet_journals", force: :cascade do |t|
    t.datetime "transaction_date"
    t.integer  "ref_id",           limit: 8
    t.integer  "ref_type_id",      limit: 4
    t.string   "owner_name_1",     limit: 255
    t.integer  "owner_id_1",       limit: 8
    t.string   "owner_name_2",     limit: 255
    t.integer  "owner_id_2",       limit: 8
    t.string   "arg_name_1",       limit: 255
    t.integer  "arg_id",           limit: 4
    t.decimal  "amount",                       precision: 20, scale: 4
    t.decimal  "balance",                      precision: 20, scale: 4
    t.string   "reason",           limit: 255,                          null: false
    t.integer  "tax_receiver_id",  limit: 8
    t.decimal  "tax_amount",                   precision: 20, scale: 4
    t.integer  "user_id",          limit: 4,                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wallet_transactions", force: :cascade do |t|
    t.datetime "transaction_date"
    t.integer  "transaction_id",         limit: 8,                                            null: false
    t.integer  "quantity",               limit: 4
    t.string   "type_name",              limit: 255
    t.integer  "type_id",                limit: 4
    t.decimal  "price",                              precision: 20, scale: 4
    t.integer  "client_id",              limit: 8
    t.string   "client_name",            limit: 255
    t.integer  "station_id",             limit: 8
    t.string   "station_name",           limit: 255
    t.string   "transaction_type",       limit: 255
    t.string   "transaction_for",        limit: 255
    t.integer  "journal_transaction_id", limit: 8
    t.integer  "client_type_id",         limit: 8
    t.boolean  "trade",                                                       default: false, null: false
    t.integer  "user_id",                limit: 4,                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "order_details", "orders", name: "order_details_order_id_fk"
  add_foreign_key "trade_details", "trades", name: "trade_details_trade_id_fk"
end
