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
    'Main/Subキャラ申請'
  end

  def has_update_operation_role(user)
    user.has_recruit_role? || user.has_api_manager_role?
  end

  def exec_done_process
    main = CorpMember.find_by(character_id: self.main_character_id)
    sub = CorpMember.find_by(character_id: self.character_id)
    if main.present? && sub.present?
      main.main_character_id = main.character_id
      main.main_character_name = main.character_name
      main.is_main = true
      sub.main_character_id = main.character_id
      sub.main_character_name = main.character_name
      sub.is_main = false

      main.save!
      sub.save!
    end
  end


end
