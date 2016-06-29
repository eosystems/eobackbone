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
  belongs_to :order_user, class_name: 'User', foreign_key: :user_id
  belongs_to :station, class_name: "StaStation", primary_key: :station_id

  EVE_CHAR_API_PATH = "https://api.eveonline.com/char/MarketOrders.xml.aspx?"

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

  def self.fetch(url)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    response = http.start {|http| http.request(request) }
    response
  end

end
