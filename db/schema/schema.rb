create_table "schema_migrations", collate: "utf8_bin", comment: "" do |t|
  t.varchar "version"

  t.index "version", name: "unique_schema_migrations", unique: true
end

create_table :orders, collate: "utf8_bin", comment: "注文" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.decimal :total_price, default: "0.000", precision: 15, scale: 3, comment: "注文合計額"
  t.varchar :processing_status, default: "waiting", comment: "処理ステータス"
  t.int :order_by, comment: "申請ユーザId"
  t.int :assigned_user_id, null: true, comment: "注文処理ユーザId"

  t.datetime :created_at
  t.datetime :updated_at
end

create_table :order_details, collate: "utf8_bin", comment: "注文明細" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :order_id
  t.int :item_id, comment: "商品Id"
  t.decimal :unit_price, default: "0.000", precision: 15, scale: 3, comment: "単価"
  t.int :quantity, comment: "数量"

  t.datetime :created_at
  t.datetime :updated_at

  t.foreign_key :order_id, reference: :orders, reference_column: :id
end

create_table :users, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :uid
  t.varchar :name, null: true
  t.varchar :token, null:true
  t.varchar :refresh_token, null:true
  t.datetime :expire, null:true
  t.varchar :encrypted_password, null: false, default: ""
  t.varchar :provider
  t.varchar :email,null: true, default: ""

  ## Recoverable
  t.varchar   :reset_password_token, null: true, default: ""
  t.datetime :reset_password_sent_at, null: true

  ## Rememberable
  t.datetime :remember_created_at, null: true

  ## Trackable
  t.int  :sign_in_count, default: 0, null: false
  t.datetime :current_sign_in_at, null: true
  t.datetime :last_sign_in_at, null: true
  t.varchar   :current_sign_in_ip, default: ""
  t.varchar   :last_sign_in_ip, default:""
  t.datetime :created_at
  t.datetime :updated_at

end

create_table :delayed_jobs, comment: 'Delayed Job' do |t|
  t.int :id, primary_key: true, extra: 'auto_increment'
  t.int :priority, default: 0, null: false
  t.int :attempts, default: 0, null: false
  t.text :handler
  t.text :last_error, null: true
  t.datetime :run_at, null: true
  t.datetime :locked_at, null: true
  t.datetime :failed_at, null: true
  t.varchar :locked_by, null: true
  t.varchar :queue, null: true

  t.datetime :created_at, null: true, comment: '作成日時'
  t.datetime :updated_at, null: true, comment: '更新日時'

  t.index [:priority, :run_at], name: 'delayed_jobs_priority'
end

create_table :market_orders, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.bigint "order_id"
  t.int "type_id"
  t.boolean "buy", null: true
  t.datetime "issued", null: true
  t.decimal "price", null: true, precision: 20, scale: 4
  t.int "volume_entered", null: true
  t.int "station_id", null: true
  t.int "volume", null: true
  t.varchar "range", null: true
  t.int "min_volume", null: true
  t.int "duration", null: true
  t.datetime "created_at", null: true
  t.datetime "updated_at", null: true


  t.index ["type_id", "buy", "station_id"], name: "index_type_id_and_buy_and_station_id"
end
