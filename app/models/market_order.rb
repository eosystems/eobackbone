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

end
