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
  THE_FORGE_REGION_ID = "10000002".freeze # The Forge
  JITA_SOLAR_SYSTEM_ID = "30000142".freeze # JITA

  def self.jita_buy_orders(item_id)
    self
      .all
      .where(buy: true)
      .where(station_id: StaStation.where(solar_system_id: JITA_SOLAR_SYSTEM_ID).map(&:station_id))
      .where(type_id: item_id)
  end

  def self.jita_buy_price(item_id)
    orders = self.jita_buy_orders(item_id)
    if orders.size == 0
      0.0
    else
      orders.map(&:price).max
    end
  end

  def self.jita_sell_orders(item_id)
    self
      .all
      .where(buy: false)
      .where(station_id: StaStation.where(solar_system_id: JITA_SOLAR_SYSTEM_ID).map(&:station_id))
      .where(type_id: item_id)
  end

  def self.jita_sell_price(item_id)
    orders = self.jita_sell_orders(item_id)
    if orders.size == 0
      0.0
    else
      orders.map(&:price).min
    end
  end

end
