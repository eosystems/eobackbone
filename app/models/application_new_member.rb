# == Schema Information
#
# Table name: application_new_members
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class ApplicationNewMember < ActiveRecord::Base
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
        entry_date: entry_date,
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
