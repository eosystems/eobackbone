# == Schema Information
#
# Table name: applications
#
#  id                :integer          not null, primary key
#  targetable_type   :string(255)      not null
#  targetable_id     :integer          not null
#  processing_status :string(255)      default("in_process"), not null
#  process_user_id   :integer
#  corporation_id    :integer
#  user_id           :integer
#  done_date         :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class Application < ActiveRecord::Base
  include NgTableSearchable
  belongs_to :targetable, polymorphic: true
  belongs_to :corporation
  belongs_to :user
  belongs_to :process_user, class_name: 'User', foreign_key: :process_user_id

  attr_accessor :management_done, :management_cancel, :management_reject, :management_in_process

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    targetable_type: :targetable_type_eq_any,
    processing_status: :processing_status_eq,
    corporation_name: :corporation_corporation_name_cont_any,
    user_name: :user_name_cont_any,
  }.with_indifferent_access.freeze

  # Delegates
  delegate :name, to: :user, allow_nil: true, prefix: :application_user
  delegate :name, to: :process_user, allow_nil: true, prefix: :process_user
  delegate :corporation_name, to: :corporation, allow_nil: true

  # Scope
  # 指定したCorpに属しているまたは自分自身であれば見ることが可能
  scope :accessible_corp_member_management, -> (corporation_id, user_id) do
    cid = arel_table[:corporation_id]
    user_id = arel_table[:user_id]

    relation_corporations = CorporationRelation.relation_corporation(corporation_id)
    where(cid.in(relation_corporations).or(user_id.eq(user_id)))
  end

  def target_type_name
    self.targetable.application_name
  end

  def exec_done_process
    self.targetable.exec_done_process
  end

  # Rejectに変更可能か
  def can_change_to_reject?(user)
    return false if self.processing_status != ProcessingStatus::IN_PROCESS.id
    self.targetable.has_update_operation_role(user)
  end

  # Cancelに変更可能か
  # - 自分のオーダー かつ in_process であれば操作可能
  def can_change_to_cancel?(user)
    my_order?(user) && self.processing_status == ProcessingStatus::IN_PROCESS.id
  end

  # Doneに変更可能か
  def can_change_to_done?(user)
    return false if self.processing_status != ProcessingStatus::IN_PROCESS.id
    self.targetable.has_update_operation_role(user)
  end

  private

  def my_order?(user)
    return false unless user.present?
    user.id == self.user_id
  end

end
