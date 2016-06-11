create_table "schema_migrations", collate: "utf8_bin", comment: "" do |t|
  t.varchar "version"

  t.index "version", name: "unique_schema_migrations", unique: true
end

create_table "users", collate: "utf8_bin", comment: "" do |t|
  t.varchar "uid", primary_key: true
  t.varchar "name", null: true
  t.varchar "token", null:true
  t.varchar "refresh_token", null:true
  t.datetime "expire", null:true
  t.varchar "encrypted_password", null: false, default: ""
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

