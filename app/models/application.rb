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

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
 }.with_indifferent_access.freeze

  # Scope
  # 指定したCorpに属している
  scope :accessible_corp_member_management, -> (corporation_id) do
    c_cid = arel_table[:corporation_id]

    where(c_cid.eq(corporation_id))
  end

end
