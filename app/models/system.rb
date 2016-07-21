# == Schema Information
#
# Table name: systems
#
#  id         :integer          not null, primary key
#  flag       :boolean          not null
#  created_at :datetime
#  updated_at :datetime
#

class System < ActiveRecord::Base
end
