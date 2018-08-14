create_table "schema_migrations", collate: "utf8_bin", comment: "" do |t|
  t.varchar "version"

  t.index "version", name: "unique_schema_migrations", unique: true
end

create_table :orders, collate: "utf8_bin", comment: "注文" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.decimal :total_price, default: "0.0000", precision: 20, scale: 4, comment: "注文合計額"
  t.decimal :total_jita_sell_price, default: "0.0000", precision: 20, scale: 4, comment: "見積"
  t.decimal :sell_price, default: "0.0000", precision: 20, scale: 4, comment: "買取合計額\t実際に買取を行う価格"
  t.decimal :total_volume, default: "0.0000", precision: 20, scale: 4, comment: "注文合計容量"
  t.boolean :is_credit, default: false, comment: "掛払フラグ\tfalseの場合は即時払い"
  t.boolean :is_paid, default: false, comment: "支払済フラグ"
  t.varchar :processing_status, default: "in_process", comment: "処理ステータス"
  t.bigint :station_id, null: true, comment: "契約場所"
  t.int :order_by, comment: "申請ユーザId"
  t.int :assigned_user_id, null: true, comment: "注文処理ユーザId"
  t.int :corporation_id, null: true, comment: "参照範囲用コープId"
  t.text :note, null: true, comment: "メモ"
  t.int :department_id, null: true, comment: "部門"
  t.boolean :is_buy, null: false, default: false
  t.decimal :total_estimate_sell_price, default: "0.0000", precision: 20, scale: 4, comment: "当初見積金額(Sell)"
  t.decimal :total_estimate_buy_price, default: "0.0000", precision: 20, scale: 4, comment: "当初見積金額(Buy)"
  t.datetime :done_date, null: true
  t.datetime :estimate_date, null: true

  t.datetime :created_at
  t.datetime :updated_at
end

create_table :order_details, collate: "utf8_bin", comment: "注文明細" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :order_id
  t.int :item_id, comment: "商品Id"
  t.decimal :unit_price, default: "0.0000", precision: 20, scale: 4, comment: "単価"
  t.decimal :sell_unit_price, default: "0.0000", precision: 20, scale: 4, comment: "買取単価"
  t.decimal :buy_unit_price, default: "0.0000", precision: 20, scale: 4, comment: "買取単価"
  t.int :quantity, comment: "数量"
  t.decimal :volume, default: "0.0000", precision: 20, scale: 4, comment: "容量"
  t.decimal :pre_sell_unit_price, default: "0.0000", precision: 20, scale: 4
  t.decimal :pre_buy_unit_price, default: "0.0000", precision: 20, scale: 4
  t.int :pre_quantity, default: 0

  t.datetime :created_at
  t.datetime :updated_at

  t.foreign_key :order_id, reference: :orders, reference_column: :id
end

create_table :api_managements, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :key_id
  t.varchar :v_code
  t.varchar :uid, comment: "メインユーザー"
  t.varchar :character_id, comment: "ユーザー"
  t.varchar :character_name, comment: "キャラクター名"
  t.varchar :corporation_id
  t.varchar :alliance_id, null: true
  t.bigint :access_mask
  t.boolean :alpha
  t.boolean :full_api
  t.datetime :expires, null: true

  t.varchar :api_manage_corporation_id, comment: "申請先コープ"
  t.datetime :created_at
  t.datetime :updated_at
end

create_table :corp_api_managements, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :key_id
  t.varchar :v_code
  t.varchar :corporation_id

  t.datetime :created_at
  t.datetime :updated_at
end

create_table :corp_wallet_divisions, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :account_key
  t.varchar :name
  t.varchar :corporation_id

  t.datetime :created_at
  t.datetime :updated_at
end


create_table :corp_wallet_journals, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.datetime :i_date
  t.bigint :ref_id
  t.int :ref_type_id, null: true
  t.varchar :owner_name1, null: true
  t.bigint :owner_id1, null: true
  t.varchar :owner_name2, null: true
  t.bigint :owner_id2, null: true
  t.varchar :arg_name1, null: true
  t.int :arg_id_1, null: true
  t.decimal :amount, default: "0.0000", precision: 20, scale: 4
  t.decimal :balance, default: "0.0000", precision: 20, scale: 4
  t.varchar :reason, null: true
  t.int :owner1_type_id, null: true
  t.int :owner2_type_id, null: true

  t.varchar :corporation_id
  t.int :corp_wallet_division_id

  t.int :mod_status, null: true
  t.boolean :ignore, default: false
  t.int :mod_ref_type_id, null: true
  t.datetime :created_at
  t.datetime :updated_at

  t.index :ref_id
end



create_table :audits, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :audit_type
  t.text :audit_text
  t.varchar :uid
  t.varchar :corporation_id
  t.datetime :created_at
  t.datetime :updated_at
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

create_table :corp_members, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :character_id, null: true
  t.varchar :character_name, null: true
  t.int :main_character_id, null: true
  t.varchar :main_character_name, null: true
  t.boolean :is_main, null: true
  t.int :corporation_id, null: true
  t.varchar :corporation_name, null: true
  t.int :manage_corporation_id, null: true
  t.varchar :manage_corporation_name, null: true
  t.varchar :corp_role, null: true
  t.boolean :token_verify, default: false
  t.boolean :token_error, default: false
  t.datetime :entry_date, null: true
  t.datetime :character_birthday, null: true
  t.datetime :created_at
  t.datetime :updated_at
end

create_table :corp_member_relations, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :character_id, null: true
  t.varchar :character_name, null: true
  t.int :main_character_id, null: true
  t.varchar :main_character_name, null: true
  t.datetime :created_at
  t.datetime :updated_at
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

create_table :corporation_relations, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: 'auto_increment'
  t.int :ancestor
  t.int :descendant
  t.boolean :only_parent, default: false

  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true

  t.index :ancestor
  t.index :descendant
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
  t.bigint :station_id, null: true
  t.int :volume, null: true
  t.varchar :range, null: true
  t.int :min_volume, null: true
  t.int :duration, null: true
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true


  t.index [:type_id, :buy, :station_id], name: "index_type_id_and_buy_and_station_id"
end

create_table :user_market_orders, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.bigint :order_id
  t.int :user_id
  t.bigint :station_id, null: true
  t.int :volume_entered, null: true
  t.int :volume_remain, null: true
  t.int :min_volume, null: true
  t.int :order_state, null: true
  t.int :type_id
  t.varchar :range, null: true
  t.varchar :account_key, null: true
  t.int :duration, null: true
  t.decimal :price, null: true, precision: 20, scale: 4
  t.boolean :buy, null: true
  t.datetime :issued, null: true
  t.boolean :monitor, null: true
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true
end

create_table :trades, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.datetime :trade_date, null: true
  t.int :type_id
  t.int :user_id
  t.int :sales_quantity, default: 0
  t.int :sales_average_price, default: 0
  t.int :purchase_quantity, default: 0
  t.int :purchase_average_price, default: 0
  t.decimal :sales, null: true, precision: 20, scale: 4, comment: "売上", default: 0
  t.decimal :cost, null: true, precision: 20, scale:4, comment: "原価", default: 0
  t.decimal :tax, null: true, precision: 20, scale: 4, comment: "税金", default: 0
  t.decimal :expense, null: true, precision: 20, scale: 4, comment: "総原価", default: 0
  t.decimal :profit, null: true, precision: 20, scale: 4, comment: "利益", default: 0
  t.decimal :inventory_valuation, null: true, precision:20, scale: 4, comment: "在庫評価額", default: 0
  t.boolean :summary, default: 0
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true
end

create_table :trade_details, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :trade_id
  t.int :user_market_order_id, null: true
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true

  t.foreign_key :trade_id, reference: :trades, reference_column: :id
end

create_table :monitor_market_orders, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.bigint :order_id
  t.int :type_id
  t.boolean :buy, null: true
  t.datetime :issued, null: true
  t.decimal :price, null: true, precision: 20, scale: 4
  t.int :volume_entered, null: true
  t.bigint :station_id, null: true
  t.int :volume, null: true
  t.varchar :range, null: true
  t.int :min_volume, null: true
  t.int :duration, null: true
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true

  t.index [:type_id, :buy, :station_id], name: "index_type_id_and_buy_and_station_id"
end

create_table :wallet_journals, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment

  t.datetime :transaction_date, null: true
  t.bigint :ref_id, null: true
  t.int :ref_type_id, null: true
  t.varchar :owner_name_1, null: true
  t.bigint :owner_id_1, null: true
  t.varchar :owner_name_2, null: true
  t.bigint :owner_id_2, null: true
  t.varchar :arg_name_1, null: true
  t.int :arg_id, null: true
  t.decimal :amount, null: true, precision: 20, scale: 4
  t.decimal :balance, null: true, precision: 20, scale: 4
  t.varchar :reason
  t.bigint :tax_receiver_id, null: true
  t.decimal :tax_amount, null: true, precision: 20, scale: 4

  t.int :user_id
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true

end

create_table :wallet_transactions, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment

  t.datetime :transaction_date, null: true
  t.bigint :transaction_id
  t.int :quantity, null: true
  t.varchar :type_name, null: true
  t.int :type_id, null: true
  t.decimal :price, null: true, precision: 20, scale: 4
  t.bigint :client_id, null: true
  t.varchar :client_name, null: true
  t.bigint :station_id, null: true
  t.varchar :station_name, null: true
  t.varchar :transaction_type, null: true
  t.varchar :transaction_for, null: true
  t.bigint :journal_transaction_id, null: true
  t.bigint :client_type_id, null: true
  t.boolean :trade, default: false

  t.int :user_id
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true

end

create_table :systems, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.boolean :flag
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true
end

create_table :departments, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :department_name
  t.boolean :delete_flag, default: false
  t.int :corporation_id, null: true
  t.int :buy_percentage, default: 90, comment: "買取利率"
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true
end

create_table :dashboards, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.text :iframe_text ,null: true
  t.varchar :title , null: true
  t.varchar :description, null: true
  t.int :corporation_id, null: true
  t.int :user_id, null: true
  t.datetime :created_at , null: true
  t.datetime :updated_at, null: true
end

create_table :applications, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :targetable_type
  t.int :targetable_id
  t.varchar :processing_status, default: 'in_process'
  t.int :process_user_id, null: true
  t.int :corporation_id, null: true
  t.int :user_id, null: true
  t.datetime :done_date, null: true
  t.datetime :created_at , null: true
  t.datetime :updated_at, null: true
end

create_table :application_new_members, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.datetime :created_at , null: true
  t.datetime :updated_at, null: true
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
  t.bigint :station_id
  t.int :region_id
  t.int :solar_system_id
  t.varchar :station_name

  t.index ["station_id"], name: "index_station_id"
  t.index ["solar_system_id"], name: "index_solar_system_id"
end

create_table :trn_translations, collate: "utf8_bin", comment: "翻訳" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :tc_id, null: true
  t.int :key_id, null: true
  t.varchar :language_id, null: true
  t.text :text, null: true
end

create_table :ref_types, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true
  t.varchar :name, null: true
  t.index ["name"], name: "index_name"
end

