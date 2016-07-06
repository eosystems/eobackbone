# == Schema Information
#
# Table name: trades
#
#  id                     :integer          not null, primary key
#  trade_date             :datetime
#  type_id                :integer          not null
#  user_id                :integer          not null
#  sales_quantity         :integer          default(0), not null
#  sales_average_price    :integer          default(0), not null
#  purchase_quantity      :integer          default(0), not null
#  purchase_average_price :integer          default(0), not null
#  sales                  :decimal(20, 4)   default(0.0)
#  cost                   :decimal(20, 4)   default(0.0)
#  tax                    :decimal(20, 4)   default(0.0)
#  expense                :decimal(20, 4)   default(0.0)
#  profit                 :decimal(20, 4)   default(0.0)
#  inventory_valuation    :decimal(20, 4)   default(0.0)
#  created_at             :datetime
#  updated_at             :datetime
#

class Trade < ActiveRecord::Base
  belongs_to :user_id, class_name: 'User', foreign_key: :user_id
  has_many :trade_details
end
