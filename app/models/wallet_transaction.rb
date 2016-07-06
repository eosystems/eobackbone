# == Schema Information
#
# Table name: wallet_transactions
#
#  id                     :integer          not null, primary key
#  transaction_date       :datetime
#  transaction_id         :integer          not null
#  quantity               :integer
#  type_name              :string(255)
#  type_id                :integer
#  price                  :decimal(20, 4)
#  client_id              :integer
#  client_name            :string(255)
#  station_id             :integer
#  station_name           :string(255)
#  transaction_type       :string(255)
#  transaction_for        :string(255)
#  journal_transaction_id :integer
#  client_type_id         :integer
#  trade                  :boolean          default(FALSE), not null
#  user_id                :integer          not null
#  created_at             :datetime
#  updated_at             :datetime
#

class WalletTransaction < ActiveRecord::Base
  include NgTableSearchable

  IMAGE_SERVER_PATH = "https://image.eveonline.com/Type/%d_32.png".freeze
  EVE_CHAR_API_PATH = "https://api.eveonline.com/char/WalletTransactions.xml.aspx?"

  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :item, foreign_key: :type_id, class_name: 'InvType'
  belongs_to :station, foreign_key: :station_id, class_name: "StaStation"
  belongs_to :wallet_journal

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    transaction_type: :transaction_type_eq,
    item_type_name: :item_type_name_cont_any,
    station_name: :station_name_cont_any,
    client_name: :client_name_cont_any,
    trade: :trade_eq
  }.with_indifferent_access.freeze

  # Delegates
  delegate :type_name, to: :item, prefix: :item

  # 参照範囲は自分のみ
  scope :accessible_orders, -> (user_id) do
    user = arel_table[:user_id]
    where(user.eq(user_id))
  end

  def image_path
    IMAGE_SERVER_PATH % [self.type_id || 0]
  end

  def self.url(key_id, v_code, character_id)
    EVE_CHAR_API_PATH + "keyID=" + key_id + "&vCode=" + v_code + "&characterID=" + character_id
  end

  def self.update(user_id)
    user = User.find(user_id)

    wallet_transactions = XmlApiBase.fetch(self.url(user.user_detail.key_id, user.user_detail.verification_code, user.uid))
    results = Hash.from_xml(wallet_transactions.body)["eveapi"]["result"]["rowset"]["row"]
    results.each do |r|
      u = WalletTransaction.find_or_initialize_by(transaction_id: r["transactionID"])
      u.attributes = {
        user_id: user_id,
        transaction_date: Time.zone.parse(r["transactionDateTime"]) + 9.hour,
        quantity: r["quantity"],
        type_name: r["typeName"],
        type_id: r["typeID"],
        price: r["price"],
        client_id: r["clientID"],
        client_name: r["clientName"],
        station_id: r["stationID"],
        station_name: r["stationName"],
        transaction_type: r["transactionType"],
        transaction_for: r["transactionFor"],
        journal_transaction_id: r["journalTransactionID"],
        client_type_id: r["clientTypeID"]
      }
      u.save!
    end
  end

end
