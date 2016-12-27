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
  has_many :departments

  def exists_corp?
    Corporation.find_by_corporation_name(self.corporation_name).present?
  end
end
