# == Schema Information
#
# Table name: user_roles
#
#  id      :integer          not null, primary key
#  user_id :integer          not null
#  role    :integer
#

class UserRole < ActiveRecord::Base
  belongs_to :user

  def self.has_contract_role(user_id)
    user = UserRole.where(user_id: user_id, role: OperationRole::CONTRACT.id)
    if user.present?
      true
    else
      false
    end
  end

end
