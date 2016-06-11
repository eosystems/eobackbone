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

  ## Recoverable
  t.varchar   :reset_password_token
  t.datetime :reset_password_sent_at

  ## Rememberable
  t.datetime :remember_created_at

  ## Trackable
  t.int  :sign_in_count, default: 0, null: false
  t.datetime :current_sign_in_at
  t.datetime :last_sign_in_at
  t.varchar   :current_sign_in_ip
  t.varchar   :last_sign_in_ip
  t.datetime :created_at
  t.datetime :updated_at

end

