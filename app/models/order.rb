# == Schema Information
#
# Table name: orders
#
#  id                        :integer          not null, primary key
#  total_price               :decimal(20, 4)   default(0.0), not null
#  total_jita_sell_price     :decimal(20, 4)   default(0.0), not null
#  sell_price                :decimal(20, 4)   default(0.0), not null
#  total_volume              :decimal(20, 4)   default(0.0), not null
#  is_credit                 :boolean          default(FALSE), not null
#  is_paid                   :boolean          default(FALSE), not null
#  processing_status         :string(255)      default("in_process"), not null
#  station_id                :integer
#  order_by                  :integer          not null
#  assigned_user_id          :integer
#  corporation_id            :integer
#  note                      :text(65535)
#  department_id             :integer
#  is_buy                    :boolean          default(FALSE), not null
#  total_estimate_sell_price :decimal(20, 4)   default(0.0), not null
#  total_estimate_buy_price  :decimal(20, 4)   default(0.0), not null
#  done_date                 :datetime
#  estimate_date             :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Order < ActiveRecord::Base
  include NgTableSearchable

  attr_accessor :management_done, :management_cancel, :management_reject, :management_in_process

  # 買取価格係数 元の価格に一定係数かけたものを買取額とする
  PURCHASE_FACTOR = 0.8

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    processing_status: :processing_status_eq,
    contract_department_name: :department_department_name_cont_any,
    contract_corporation_name: :corporation_corporation_name_cont_any,
    contract_user_name: :order_user_name_cont_any,
  }.with_indifferent_access.freeze

  # Relations
  has_many :order_details, dependent: :destroy
  belongs_to :corporation, foreign_key: "corporation_id"
  belongs_to :order_user, class_name: 'User', foreign_key: :order_by
  belongs_to :station, class_name: "StaStation", primary_key: :station_id
  belongs_to :department

  # Hooks
  before_create :set_default_paid_status

  # Delegates
  delegate :station_name, to: :station, allow_nil: true, prefix: :contract
  delegate :department_name, to: :department, allow_nil: true, prefix: :contract
  delegate :corporation_name, to: :corporation, allow_nil: true, prefix: :contract
  delegate :name, to: :order_user, allow_nil: true, prefix: :contract_user
  # Scopes

  # 指定したCorpに属している、または指定したユーザIDが出した注文であれば参照可能
  scope :accessible_orders, -> (corporation_id, user_id, operation_auth: false) do
    cid = arel_table[:corporation_id]
    order_by = arel_table[:order_by]

    relation_corporations = CorporationRelation.relation_corporation(corporation_id, operation_auth: operation_auth)
    where(cid.in(relation_corporations).or(order_by.eq(user_id)))
  end

  scope :buy_orders, -> do
    where(is_buy: true)
  end

  scope :sell_orders, -> do
    where(is_buy: false)
  end

  def retrieval!
    self.order_details.each(&:retrieval!)
    self.total_volume = order_details.map(&:volume).sum
    self.total_price = order_details.map(&:price).sum
    self.sell_price = (order_details.map(&:sell_price).sum * PURCHASE_FACTOR).round(2)
  end

  def parse_buy_orders(form)
    form.each do |f|
      i = InvType.where(type_id: f[:type_id]).first
      self.order_details.build(
        quantity: 0,
        item_id: f[:type_id],
        pre_sell_unit_price: f[:sell_price],
        pre_buy_unit_price: f[:buy_unit_price],
        pre_quantity: f[:quantity],
        volume: i.volume
      )
    end
    self
  end

  def update_buy_orders(form)
    form.each do |f|
      c = self.order_details.find(f[:id])
      c.unit_price = f[:unit_price]
      c.sell_unit_price = f[:sell_unit_price]
      c.buy_unit_price = f[:buy_unit_price]
      c.quantity = f[:quantity]
      c.save
    end
    self
  end

  # In Processに変更可能か
  # - 自分の契約の場合はキャンセルの場合に戻せる
  # - ユーザが契約管理権限を持っていない場合は In Process に戻せる
  def can_change_to_in_process?(user)
    return true if my_order?(user) && self.processing_status == ProcessingStatus::CANCELED.id
    return true if user.has_contract_role?
    false
  end

  def can_change_to_undo?(user)
    return true if user.has_contract_role?
    return true if my_order?(user) && self.processing_status == ProcessingStatus::ACCEPT.id
    return true if my_order?(user) && self.processing_status == ProcessingStatus::REJECT.id

    false
  end

  # Rejectに変更可能か
  # - 契約管理権限を持っている場合は操作可能
  def can_change_to_reject?(user)
    user.has_contract_role?
  end

  def can_change_to_accept_for_buy?(user)
    return true if my_order?(user) && (
      self.processing_status == ProcessingStatus::CREATE_CONTRACT.id
    )
    return true if user.has_contract_role? && (
      self.processing_status == ProcessingStatus::CREATE_CONTRACT.id
    )
    false
  end

  def can_change_to_reject_for_buy?(user)
    return true if my_order?(user) && (
      self.processing_status == ProcessingStatus::CREATE_CONTRACT.id
    )
    return true if user.has_contract_role? && (
      self.processing_status == ProcessingStatus::CREATE_CONTRACT.id
    )
    false
  end

  def can_change_to_delete?(user)
    return true if my_order?(user) && self.processing_status == ProcessingStatus::IN_PROCESS.id
    return true if user.has_contract_role? && self.processing_status == ProcessingStatus::IN_PROCESS.id
    false
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

  def can_create_contract?(user)
    return true if user.has_contract_role? && self.processing_status == ProcessingStatus::IN_PROCESS.id
    false
  end

  def my_order?(user)
    return false unless user.present?
    user.id == self.order_by
  end

  def set_default_paid_status
    self.is_paid = if is_credit
                     false
                   else
                     true
                   end
    true
  end
end
