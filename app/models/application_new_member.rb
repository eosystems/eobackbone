# == Schema Information
#
# Table name: application_new_members
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class ApplicationNewMember < ActiveRecord::Base
  include NgTableSearchable
end
