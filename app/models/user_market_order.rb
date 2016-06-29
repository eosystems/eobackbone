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
end
