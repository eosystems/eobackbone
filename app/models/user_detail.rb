# == Schema Information
#
# Table name: user_details
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  corporation_id    :integer
#  alliance_id       :integer
#  key_id            :string(255)
#  verification_code :string(255)
#

class UserDetail < ActiveRecord::Base
  belongs_to :user
  belongs_to :corporation, primary_key: 'corporation_id'
end
