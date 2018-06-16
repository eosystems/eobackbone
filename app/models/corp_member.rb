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
  include NgTableSearchable
  belongs_to :user, foreign_key: "character_id", primary_key: :uid
  belongs_to :main_user, class_name: "User", foreign_key: "main_character_id", primary_key: :uid
  belongs_to :corporation

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    character_name: :character_name_cont_any,
    corporation_name: :corporation_name_cont_any,
    main_character_name: :main_character_name_cont_any,
    token_verify: :token_verify_eq_any,
    token_error: :token_erro_eq_any
  }.with_indifferent_access.freeze

  def member_token_refresh
    if user.present?

    end
  end
end
