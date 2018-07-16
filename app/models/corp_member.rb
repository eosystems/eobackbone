# == Schema Information
#
# Table name: corp_members
#
#  id                      :integer          not null, primary key
#  character_id            :integer
#  character_name          :string(255)
#  main_character_id       :integer
#  main_character_name     :string(255)
#  corporation_id          :integer
#  corporation_name        :string(255)
#  manage_corporation_id   :integer
#  manage_corporation_name :string(255)
#  token_verify            :boolean          default(FALSE), not null
#  token_error             :boolean          default(FALSE), not null
#  entry_date              :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
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

  def self.update_corp_member(corporation_id: User.admin_corp)
    is_success, character_ids = self.fetch_corp_member(corporation_id: corporation_id)
    if is_success
      character_ids.each do |character_id|
        member = CorpMember.find_by(character_id: character_id)
        if member.nil?
          member = CorpMember.new
          character_info = Character.info(character_id)
          entry_date = Character.entry_corp_date(character_id, corporation_id)
          role = Character.corp_role(character_id, corporation_id)
          member.attributes = {
            character_id: character_id,
            character_name: character_info.try(:name),
            character_birthday: character_info.try(:birthday),
            corporation_id: corporation_id,
            corporation_name: Corporation.find_by(corporation_id: corporation_id).try(:corporation_name),
            entry_date: entry_date,
            corp_role: role,
            manage_corporation_id: corporation_id,
            manage_corporation_name: Corporation.find_by(corporation_id: corporation_id).try(:corporation_name),
          }
        else
          role = Character.corp_role(character_id, corporation_id)
          member.attributes = {
            corp_role: role,
          }
        end
        member.save
      end

      # TODO 退社処理を書く
    end
  end

  def self.fetch_corp_member(corporation_id: User.admin_corp)
    token = User.admin_token
    client = EsiClient.new(token)
    response = client.fetch_corp_member(corporation_id)
    if response.is_success
      [response.is_success, response.items]
    else
      [response.is_success, []]
    end
  end

end
