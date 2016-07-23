# == Schema Information
#
# Table name: departments
#
#  id              :integer          not null, primary key
#  department_name :string(255)      not null
#  delete_flag     :boolean          default(FALSE), not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Department < ActiveRecord::Base
  has_many :orders
end
