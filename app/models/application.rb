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

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
 }.with_indifferent_access.freeze

  # Scope
  # 指定したCorpに属しているまたは自分自身であれば見ることが可能
  scope :accessible_corp_member_management, -> (corporation_id, user_id) do
    cid = arel_table[:corporation_id]
    user_id = arel_table[:user_id]

    relation_corporations = CorporationRelation.relation_corporation(corporation_id)
    where(cid.in(relation_corporations).or(user_id.eq(user_id)))
  end

end
