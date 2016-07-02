# == Schema Information
#
# Table name: trade_details
#
#  id                   :integer          not null, primary key
#  trade_id             :integer          not null
#  user_market_order_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class TradeDetail < ActiveRecord::Base
  belongs_to :trade, class_name: 'Trade', foreign_key: :trade_id
  belongs_to :user_market_order
end
