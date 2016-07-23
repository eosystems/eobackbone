# == Schema Information
#
# Table name: departments
#
#  id              :integer          not null, primary key
#  department_name :string(255)      not null
#  delete_flag     :boolean          default(FALSE), not null
#  corporation_id  :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Department < ActiveRecord::Base
  has_many :orders
  belongs_to :corporation
end
