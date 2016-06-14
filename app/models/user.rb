# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  uid                    :string(255)      not null
#  name                   :string(255)
#  token                  :string(255)
#  refresh_token          :string(255)
#  expire                 :datetime
#  encrypted_password     :string(255)      default(""), not null
#  provider               :string(255)      not null
#  email                  :string(255)      default("")
#  reset_password_token   :string(255)      default("")
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)      default(""), not null
#  last_sign_in_ip        :string(255)      default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :omniauthable
  has_one :user_detail

  def self.find_for_eve_online_oauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    unless user
      user = User.create(
        name: auth.info.character_name,
        provider: auth.provider,
        uid: auth.uid,
        token: auth.credentials.token,
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  def email_required?
    false
  end

  # 契約管理権限を持っているか
  def has_contract_management_authority?
    true # TODO: FIXME
  end

  def self.get_character_account_read(token, account_id)
    account_info = token.get('https://api.eveonline.com/eve/CharacterInfo.xml.aspx?characterID=' + account_id)
    result = Hash.from_xml(account_info.body)["eveapi"]["result"]
    character = Character.new
    character.character_id = result["characterID"]
    character.character_name = result["characterName"]
    character.corporation_id = result["corporationID"] if result["corporationID"].present?
    character.corporation_name = result["corporation"] if result["corporation"].present?
    character.alliance_id = result["allianceID"] if result["allianceID"].present?
    character.alliance_name = result["alliance"] if result["alliance"].present?
    character
  end
end
