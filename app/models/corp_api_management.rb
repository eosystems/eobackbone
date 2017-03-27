# == Schema Information
#
# Table name: corp_api_managements
#
#  id             :integer          not null, primary key
#  key_id         :string(255)      not null
#  v_code         :string(255)      not null
#  corporation_id :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class CorpApiManagement < ActiveRecord::Base
  belongs_to :corporation

end
