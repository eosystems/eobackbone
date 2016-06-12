# == Schema Information
#
# Table name: market_orders
#
#  id             :integer          not null, primary key
#  order_id       :integer          not null
#  type_id        :integer          not null
#  buy            :boolean
#  issued         :datetime
#  price          :decimal(20, 4)
#  volume_entered :integer
#  station_id     :integer
#  volume         :integer
#  range          :string(255)
#  min_volume     :integer
#  duration       :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class MarketOrder < ActiveRecord::Base
  JITA_REGION_ID = "10000002".freeze # JITA

  def self.jita_buy_orders(item_id)
    self
      .all
      .where(buy: true)
      .where(station_id: StaStation.where(region_id: JITA_REGION_ID).map(&:station_id))
      .where(type_id: item_id)
  end

  # TODO: 一番買取価格の高いものを引いてきているが、これでよいのか
  def self.jita_buy_price(item_id)
    orders = self.jita_buy_orders(item_id)
    orders.map(&:price).max
    if orders.size == 0
      0.0
    end
  end
end
