# == Schema Information
#
# Table name: monitor_items
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  station_id :integer
#  type_id    :integer          not null
#  count      :integer          not null
#  stop       :boolean
#  created_at :datetime
#  updated_at :datetime
#

class MonitorItem < ActiveRecord::Base
  belongs_to :monitor_user, class_name: 'User', foreign_key: :user_id
  belongs_to :station, class_name: "StaStation", primary_key: :station_id
end
