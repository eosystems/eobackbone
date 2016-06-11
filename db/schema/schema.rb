create_table "schema_migrations", collate: "utf8_bin", comment: "" do |t|
  t.varchar "version"

  t.index "version", name: "unique_schema_migrations", unique: true
end

create_table :orders, collate: "utf8_bin", comment: "注文" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.decimal :total_price, default: "0.000", precision: 15, scale: 3, comment: "注文合計額"
  t.varchar :processing_status, default: "waiting", comment: "処理ステータス"
  t.int :order_by, comment: "申請ユーザId"
  t.int :assigned_user_id, comment: "注文処理ユーザId"

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

