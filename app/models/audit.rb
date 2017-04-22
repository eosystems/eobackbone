# == Schema Information
#
# Table name: audits
#
#  id             :integer          not null, primary key
#  audit_type     :string(255)      not null
#  audit_text     :text(65535)      not null
#  uid            :string(255)      not null
#  corporation_id :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Audit < ActiveRecord::Base
  include NgTableSearchable

  belongs_to :user, class_name: 'User',foreign_key: :uid, primary_key: :uid
  belongs_to :corporation

  scope :accessible_corp_audit, -> (user_id) do
    cid = arel_table[:corporation_id]
    user_corporation_id = User.find(user_id).user_detail.corporation_id

    relation_corporations = CorporationRelation.relation_corporation(user_corporation_id)
    where(cid.in(relation_corporations))
  end


end
