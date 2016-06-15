# == Schema Information
#
# Table name: corporations
#
#  corporation_id   :integer          not null, primary key
#  corporation_name :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Corporation < ActiveRecord::Base
end
