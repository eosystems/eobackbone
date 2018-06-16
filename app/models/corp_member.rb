# == Schema Information
#
# Table name: corp_members
#
#  id                  :integer          not null, primary key
#  character_id        :integer
#  character_name      :string(255)
#  main_character_id   :integer
#  main_character_name :string(255)
#  corporation_id      :integer
#  corporation_name    :string(255)
#  token_verify        :boolean          default(FALSE), not null
#  token_error         :boolean          default(FALSE), not null
#  entry_date          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class CorpMember < ActiveRecord::Base
end
