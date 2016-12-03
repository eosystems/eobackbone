# == Schema Information
#
# Table name: api_managements
#
#  id             :integer          not null, primary key
#  key_id         :string(255)      not null
#  v_code         :string(255)      not null
#  uid            :string(255)      not null
#  character_id   :string(255)      not null
#  corporation_id :string(255)      not null
#  alliance_id    :string(255)      not null
#  access_mask    :string(255)      not null
#  alpha          :boolean          not null
#  full_api       :boolean          not null
#  expires        :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ApiManagement < ActiveRecord::Base

  belongs_to :user, class_name: 'User', foreign_key: :user_id
end
