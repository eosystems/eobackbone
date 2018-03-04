# == Schema Information
#
# Table name: user_roles
#
#  id      :integer          not null, primary key
#  user_id :integer          not null
#  role    :integer
#

class UserRole < ActiveRecord::Base
  include NgTableSearchable
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user
  belongs_to_active_hash :operation_role, foreign_key: :role

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    role_user_name: :user_name_cont_any,
    role: :role_eq_any,
  }.with_indifferent_access.freeze

  delegate :name, to: :user , prefix: :role_user
  delegate :name, to: :operation_role, prefix: :operation_role

  # Scope
  # 指定したCorpに属している
  scope :accessible_corp_management, -> (corporation_id) do
    user_detail = UserDetail.arel_table
    role = UserRole.arel_table
    join_condition = role.join(user_detail, Arel::Nodes::InnerJoin).
      on(role[:user_id].eq(user_detail[:user_id])).join_sources

    relation_corporations = CorporationRelation.relation_corporation(corporation_id)

    joins(join_condition).where(user_details: { corporation_id: relation_corporations} )
  end

end
