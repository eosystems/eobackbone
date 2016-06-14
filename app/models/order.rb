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
#  order_by          :integer          not null
#  assigned_user_id  :integer
#  corporation_id    :integer
#  note              :text(65535)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Order < ActiveRecord::Base
  include NgTableSearchable

  attr_accessor :management_done, :management_cancel, :management_reject, :management_in_process

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    processing_status: :processing_status_eq,
  }.with_indifferent_access.freeze

  # Relations
  has_many :order_details
  belongs_to :corp, foreign_key: "corporation_id"

  # Scopes

  # 指定したCorpに属している、または指定したユーザIDが出した注文であれば参照可能
  scope :accessable_orders, -> (corporation_id, user_id) do
    cid = arel_table[:corporation_id]
    order_by = arel_table[:order_by]
    where(cid.eq(corporation_id).or(order_by.eq(user_id)))
  end

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

  # In Processに変更可能か
  # - ユーザが契約管理権限を持っていない場合は In Process には戻せない
  # - ステータスがDone または Rejectの場合は In Processには変更不可
  def can_change_to_in_process?(user)
    return false unless user.has_contract_role?
    (self.processing_status != ProcessingStatus::DONE.id &&
     self.processing_status != ProcessingStatus::REJECT.id)
  end

  # Rejectに変更可能か
  # - 契約管理権限を持っている場合は操作可能
  def can_change_to_reject?(user)
    user.has_contract_role?
  end

  # Cancelに変更可能か
  # - 自分のオーダー かつ in_process であれば操作可能
  def can_change_to_cancel?(user)
    my_order?(user) && self.processing_status == ProcessingStatus::IN_PROCESS.id
  end

  # Doneに変更可能か
  # - 契約管理権限を持っている場合は操作可能
  def can_change_to_done?(user)
    user.has_contract_role?
  end

  def my_order?(user)
    return false unless user.present?
    user.id == self.order_by
  end
end
