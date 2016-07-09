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
#  summary                :boolean          default(FALSE), not null
#  created_at             :datetime
#  updated_at             :datetime
#

class Trade < ActiveRecord::Base
  include NgTableSearchable

  IMAGE_SERVER_PATH = "https://image.eveonline.com/Type/%d_32.png".freeze

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    trade_date: :trade_date_cont_any,
    item_type_name: :item_type_name_cont_any
  }.with_indifferent_access.freeze


  belongs_to :user_id, class_name: 'User', foreign_key: :user_id
  belongs_to :item, foreign_key: :type_id, class_name: 'InvType'
  has_many :trade_details

  # Delegates
  delegate :type_name, to: :item, prefix: :item

  # Scopes

  # 参照範囲は自分のみ
  scope :accessible_orders, -> (user_id) do
    user = arel_table[:user_id]
    where(user.eq(user_id))
  end

  def image_path
    IMAGE_SERVER_PATH % [self.type_id || 0]
  end

end
