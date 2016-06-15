# == Schema Information
#
# Table name: user_roles
#
#  id      :integer          not null, primary key
#  user_id :integer          not null
#  role    :integer
#

class UserRole < ActiveRecord::Base
  belongs_to :user
end
