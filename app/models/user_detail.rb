# == Schema Information
#
# Table name: user_details
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  corporation_id :integer
#  alliance_id    :integer
#

class UserDetail < ActiveRecord::Base
  belongs_to :user
end
