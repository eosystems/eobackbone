# == Schema Information
#
# Table name: user_market_orders
#
#  id             :integer          not null, primary key
#  order_id       :integer          not null
#  user_id        :integer          not null
#  station_id     :integer
#  volume_entered :integer
#  volume_remain  :integer
#  min_volume     :integer
#  order_state    :integer
#  type_id        :integer          not null
#  range          :string(255)
#  account_key    :string(255)
#  duration       :integer
#  price          :decimal(20, 4)
#  buy            :boolean
#  issued         :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

class UserMarketOrder < ActiveRecord::Base
  include NgTableSearchable

  IMAGE_SERVER_PATH = "https://image.eveonline.com/Type/%d_32.png".freeze
  EVE_CHAR_API_PATH = "https://api.eveonline.com/char/MarketOrders.xml.aspx?"

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    order_state: :order_state_eq,
    buy: :buy_eq,
    item_type_name: :item_type_name_cont_any,
    order_station_name: :station_station_name_cont_any,
    monitor: :monitor_eq
  }.with_indifferent_access.freeze

  # Relations
  belongs_to :order
  belongs_to :order_user, class_name: 'User', foreign_key: :user_id
  belongs_to :item, foreign_key: :type_id, class_name: 'InvType'
  belongs_to :station, foreign_key: :station_id, class_name: "StaStation"

  # Delegates
  delegate :type_name, to: :item, prefix: :item
  delegate :station_name, to: :station, allow_nil: true, prefix: :order

  # Scopes

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

    user_market_orders = self.fetch(self.url(user.user_detail.key_id, user.user_detail.verification_code, user.uid))
    results = Hash.from_xml(user_market_orders.body)["eveapi"]["result"]["rowset"]["row"]
    results.each do |r|
      u = UserMarketOrder.find_or_initialize_by(order_id: r["orderID"])
      u.attributes = {
        user_id: user_id,
        station_id: r["stationID"],
        volume_entered: r["volEntered"],
        volume_remain: r["volRemaining"],
        min_volume: r["minVolume"],
        order_state: r["orderState"],
        type_id: r["typeID"],
        range: r["range"],
        account_key: r["accountKey"],
        duration: r["duration"],
        price: r["price"],
        buy: r["bid"],
        issued: r["issued"]
      }
      u.save!
    end
  end

  def monitor_market_orders
    if self.buy
      MonitorMarketOrder
        .where(type_id: self.type_id, station_id: self.station_id, buy: true)
        .order(price: :desc).limit(15)
    else
      MonitorMarketOrder
        .where(type_id: self.type_id, station_id: self.station_id, buy: false)
        .order(price: :asc).limit(15)
    end
  end

  # 勝ち負け
  def lose_or_win
    if self.order_state == OrderStatus::OPEN.id
      top_order = nil
      if self.buy
        top_order = MonitorMarketOrder.
          where(type_id: self.type_id, station_id: self.station_id, buy: true)
          .order(price: :desc)
          .first
      else
        top_order = MonitorMarketOrder.
          where(type_id: self.type_id, station_id: self.station_id, buy: false)
          .order(price: :asc)
          .first
      end

      if top_order == nil
        return ""
      end
      if top_order.order_id == self.order_id
        return "win"
      else
        return "lose"
      end
    else
      ""
    end
  end

  def self.fetch(url)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    response = http.start {|http| http.request(request) }
    response
  end

end
