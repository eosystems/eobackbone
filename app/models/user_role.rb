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
end
