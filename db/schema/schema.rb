create_table "schema_migrations", collate: "utf8_bin", comment: "" do |t|
  t.varchar "version"

  t.index "version", name: "unique_schema_migrations", unique: true
end

create_table :orders, collate: "utf8_bin", comment: "注文" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.decimal :total_price, default: "0.0000", precision: 20, scale: 4, comment: "注文合計額"
  t.decimal :sell_price, default: "0.0000", precision: 20, scale: 4, comment: "買取合計額\t実際に買取を行う価格"
  t.decimal :total_volume, default: "0.0000", precision: 20, scale: 4, comment: "注文合計容量"
  t.boolean :is_credit, default: false, comment: "掛払フラグ\tfalseの場合は即時払い"
  t.varchar :processing_status, default: "in_process", comment: "処理ステータス"
  t.int :station_id, null: true, comment: "契約場所"
  t.int :order_by, comment: "申請ユーザId"
  t.int :assigned_user_id, null: true, comment: "注文処理ユーザId"
  t.int :corporation_id, null: true, comment: "参照範囲用コープId"
  t.text :note, null: true, comment: "メモ"

  t.datetime :created_at
  t.datetime :updated_at
end

create_table :order_details, collate: "utf8_bin", comment: "注文明細" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :order_id
  t.int :item_id, comment: "商品Id"
  t.decimal :unit_price, default: "0.0000", precision: 20, scale: 4, comment: "単価"
  t.decimal :sell_unit_price, default: "0.0000", precision: 20, scale: 4, comment: "買取単価"
  t.int :quantity, comment: "数量"
  t.decimal :volume, default: "0.0000", precision: 20, scale: 4, comment: "容量"

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

create_table :user_details, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :user_id
  t.int :corporation_id, null: true
  t.int :alliance_id, null: true
  t.varchar :key_id, null: true
  t.varchar :verification_code, null: true
end

create_table :user_roles, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :user_id
  t.int :role, null: true
end

create_table :corporations, collate: "utf8_bin" do |t|
  t.int :corporation_id, primary_key: true
  t.varchar :corporation_name
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
  t.bigint :order_id
  t.int :type_id
  t.boolean :buy, null: true
  t.datetime :issued, null: true
  t.decimal :price, null: true, precision: 20, scale: 4
  t.int :volume_entered, null: true
  t.int :station_id, null: true
  t.int :volume, null: true
  t.varchar :range, null: true
  t.int :min_volume, null: true
  t.int :duration, null: true
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true


  t.index [:type_id, :buy, :station_id], name: "index_type_id_and_buy_and_station_id"
end


# master
create_table :inv_types, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :type_id
  t.int :group_id, null: true
  t.varchar :type_name, null: true
  t.text :description, null: true
  t.double :mass, null: true
  t.double :volume, null: true
  t.decimal :base_price, null: true, precision: 20, scale: 4
  t.int :market_group_id, null: true

  t.index ["type_id"], name: "index_type_id"
  t.index ["type_name"], name: "index_type_name"
end

create_table :map_regions, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :region_id, primary_key: true
  t.varchar :region_name, null: true

  t.index ["region_id"], name: "index_region_id"
  t.index ["region_name"], name: "index_region_name"
end

create_table :map_solar_systems, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :region_id
  t.int :solar_system_id
  t.varchar :solar_system_name

  t.index ["region_id"], name: "index_region_id"
  t.index ["solar_system_id"], name: "index_solar_system_id"
end

create_table :sta_stations, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :station_id
  t.int :region_id
  t.int :solar_system_id
  t.varchar :station_name

  t.index ["station_id"], name: "index_station_id"
  t.index ["solar_system_id"], name: "index_solar_system_id"
end
