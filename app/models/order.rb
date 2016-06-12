# == Schema Information
#
# Table name: orders
#
#  id                :integer          not null, primary key
#  total_price       :decimal(20, 4)   default(0.0), not null
#  sell_price        :decimal(20, 4)   default(0.0), not null
#  total_volume      :decimal(20, 4)   default(0.0), not null
#  is_credit         :boolean          default(FALSE), not null
#  processing_status :string(255)      default("in_process"), not null
#  station_id        :integer
#  processing_status :string(255)      default("in_process"), not null
#  order_by          :integer          not null
#  assigned_user_id  :integer
#  note              :text(65535)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Order < ActiveRecord::Base
  include NgTableSearchable

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    processing_status: :processing_status_eq,
  }.with_indifferent_access.freeze

  # Relations
  has_many :order_details

  def retrieval!
    self.order_details.each(&:retrieval!)
    self.total_volume = order_details.map(&:volume).sum
    self.total_price = order_details.map(&:price).sum
    self.sell_price = order_details.map(&:sell_price).sum
  end

  def self.available_orders(user)
    if user.has_contract_management_authority?
      all
    else
      all.where(order_by: user.id)
    end
  end

  # 未処理の注文
  # - ユーザが契約管理権限を持っている場合は、Corp宛の未処理の注文を返す
  # - ユーザが契約管理権限を持っていない場合は、自身の未処理注文を返す
  def self.in_process_orders(user)
    if user.has_contract_management_authority?
      self
        .available_orders(user)
        .where(processing_status: ProcessingStatus::IN_PROCESS.id)
    else
      self
        .available_orders(user)
        .where(processing_status: ProcessingStatus::IN_PROCESS.id)
        .where(order_by: user.id)
    end
  end
end
