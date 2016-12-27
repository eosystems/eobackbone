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
    c_uid = arel_table[:uid]
    where(c_uid.eq(user_id))
  end


end
