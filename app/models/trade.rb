# == Schema Information
#
# Table name: trades
#
#  id         :integer          not null, primary key
#  type_id    :integer          not null
#  user_id    :integer          not null
#  revenue    :decimal(20, 4)
#  expense    :decimal(20, 4)
#  profit     :decimal(20, 4)
#  created_at :datetime
#  updated_at :datetime
#

class Trade < ActiveRecord::Base
  belongs_to :user_id, class_name: 'User', foreign_key: :user_id
  has_many :trade_details
end
