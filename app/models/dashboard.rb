# == Schema Information
#
# Table name: dashboards
#
#  id             :integer          not null, primary key
#  iframe_text    :text(65535)
#  title          :string(255)
#  description    :string(255)
#  corporation_id :integer
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Dashboard < ActiveRecord::Base
  include NgTableSearchable

  belongs_to :user, class_name: 'User'
  belongs_to :corporation

  scope :accessible_corp, -> (user_id) do
    cid = arel_table[:corporation_id]
    user_corporation_id = User.find(user_id).user_detail.corporation_id

    relation_corporations = CorporationRelation.relation_corporation(user_corporation_id)
    where(cid.in(relation_corporations))
  end


end
