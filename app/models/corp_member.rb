# == Schema Information
#
# Table name: corp_members
#
#  id                      :integer          not null, primary key
#  character_id            :integer
#  character_name          :string(255)
#  main_character_id       :integer
#  main_character_name     :string(255)
#  is_main                 :boolean
#  corporation_id          :integer
#  corporation_name        :string(255)
#  manage_corporation_id   :integer
#  manage_corporation_name :string(255)
#  corp_role               :string(255)
#  token_verify            :boolean          default(FALSE), not null
#  token_error             :boolean          default(FALSE), not null
#  entry_date              :datetime
#  character_birthday      :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class CorpMember < ActiveRecord::Base
  include NgTableSearchable
  belongs_to :user, foreign_key: "character_id", primary_key: :uid
  belongs_to :main_user, class_name: "User", foreign_key: "main_character_id", primary_key: :uid
  belongs_to :corporation
  belongs_to :management_corporation, class_name: 'Corporation', foreign_key: :manage_corporation_id

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    is_main: :is_main_eq_any,
    character_name: :character_name_cont_any,
    corporation_name: :corporation_name_cont_any,
    main_character_name: :main_character_name_cont_any,
    token_verify: :token_verify_eq_any,
    token_error: :token_erro_eq_any
  }.with_indifferent_access.freeze

  # Scope
  # 指定したCorpに属している
  scope :accessible_corp_member_management, -> (corporation_id) do
    cid = arel_table[:manage_corporation_id]

    relation_corporations = CorporationRelation.relation_corporation(corporation_id)
    where(cid.in(relation_corporations))
  end

  def self.update_corp_member(corporation_id: User.admin_corp)
    is_success, character_ids = self.fetch_corp_member(corporation_id: corporation_id)
    if is_success
      character_ids.each do |character_id|
        member = CorpMember.find_by(character_id: character_id)
        if member.nil?
          member = CorpMember.new
          character_info = Character.info(character_id)
          member.attributes = {
            character_id: character_id,
            character_name: character_info.try(:name),
            character_birthday: character_info.try(:birthday),
            corporation_id: corporation_id,
            corporation_name: Corporation.find_by(corporation_id: corporation_id).try(:corporation_name),
            manage_corporation_id: corporation_id,
            manage_corporation_name: Corporation.find_by(corporation_id: corporation_id).try(:corporation_name),
          }
        else
          role = Character.title(character_id)
          if role.nil?
            member.attributes = {
              token_verify: false
            }
          else
            entry_date = Character.entry_corp_date(character_id, corporation_id)
            member.attributes = {
              entry_date: entry_date,
              corp_role: role,
              token_verify: true,
            }
          end
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
