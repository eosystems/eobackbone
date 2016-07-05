# == Schema Information
#
# Table name: trades
#
#  id                     :integer          not null, primary key
#  trade_date             :datetime
#  type_id                :integer          not null
#  user_id                :integer          not null
#  sales_quantity         :integer          not null
#  sales_average_price    :integer          not null
#  purchase_quantity      :integer          not null
#  purchase_average_price :integer          not null
#  sales                  :decimal(20, 4)
#  cost                   :decimal(20, 4)
#  tax                    :decimal(20, 4)
#  expense                :decimal(20, 4)
#  profit                 :decimal(20, 4)
#  inventory_valuation    :decimal(20, 4)
#  created_at             :datetime
#  updated_at             :datetime
#

class Trade < ActiveRecord::Base
  belongs_to :user_id, class_name: 'User', foreign_key: :user_id
  has_many :trade_details
end
