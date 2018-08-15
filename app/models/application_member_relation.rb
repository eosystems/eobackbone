# == Schema Information
#
# Table name: application_member_relations
#
#  id                  :integer          not null, primary key
#  character_id        :integer
#  character_name      :string(255)
#  main_character_id   :integer
#  main_character_name :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ApplicationMemberRelation < ActiveRecord::Base
  include NgTableSearchable
  include Applicationable

  def application_name
    'メンバー新規申請'
  end

  def has_update_operation_role(user)
    user.has_recruit_role? || user.has_api_manager_role?
  end

  def exec_done_process
    target_user = User.find(self.application.user_id)
    if CorpMember.find_by(character_id: target_user.uid).blank?
      corporation_id = self.application.corporation_id
      character_id = target_user.uid

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
        token_verify: true,
      }

      member.save!
    end
  end


end
