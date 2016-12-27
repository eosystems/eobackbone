# == Schema Information
#
# Table name: api_managements
#
#  id                        :integer          not null, primary key
#  key_id                    :string(255)      not null
#  v_code                    :string(255)      not null
#  uid                       :string(255)      not null
#  character_id              :string(255)      not null
#  character_name            :string(255)      not null
#  corporation_id            :string(255)      not null
#  alliance_id               :string(255)
#  access_mask               :integer          not null
#  alpha                     :boolean          not null
#  full_api                  :boolean          not null
#  expires                   :datetime
#  api_manage_corporation_id :string(255)      not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class ApiManagement < ActiveRecord::Base
  include NgTableSearchable

  belongs_to :corporation
  belongs_to :api_management_corporation, class_name: 'Corporation', foreign_key: :api_manage_corporation_id
  belongs_to :main_user, class_name: 'User', foreign_key: :uid

  attr_accessor :all_check
  attr_accessor :check_lists # APICheck結果
  attr_accessor :characters # Character一覧

  RANSACK_FILTER_ATTRIBUTES = {
    id: :id_eq_any,
    key_id: :key_id_cont_any,
    character_name: :character_name_cont_any,
    corporation_name: :corporation_corporation_name_cont_any,
    api_management_corporation_corporation_name: :api_management_corporation_corporation_name_cont_any,
    main_user_name: :main_user_name_cont_any,
    alpha: :alpha_eq_any,
    full_api: :full_api_eq_any
  }.with_indifferent_access.freeze

  # Delegates
  delegate :corporation_name, to: :corporation, allow_nil: true
  delegate :corporation_name, to: :api_management_corporation, allow_nil: true, prefix: 'api_management_corporation'
  delegate :name, to:  :main_user, allow_nil: true, prefix: 'main_user'

  # Scope
  # 指定したCorpに属している
  scope :accessible_corp_api_management, -> (user_id, character_id, corporation_id) do
    c_cid = arel_table[:api_manage_corporation_id]
    c_uid = arel_table[:uid]
    c_character_id = arel_table[:character_id]

    where(c_cid.eq(corporation_id).or(c_uid.eq(user_id).or(c_character_id.eq(character_id))))
  end

  # 自分
  scope :accessible_self_api_management, -> (user_id, character_id) do
    c_uid = arel_table[:uid]
    c_character_id = arel_table[:character_id]

    where(c_uid.eq(user_id).or(c_character_id.eq(character_id)))
  end


  # Methods

  def api_check(key_id, v_code)
    client = EveClient.new(key_id, v_code)
    response = client.fetch_api_key_info
    response_account_status = client.fetch_account_status
    item = response.items[0].key
    self.access_mask = item.accessMask
    self.expires = item.expires
    self.alpha = self.alpha_check(response_account_status.items[0].paidUntil)
    self.full_api = self.full_api?
    self.all_check = application_check(self.full_api, self.expires)
    self.characters = get_characters_from_api_key_info(item.rowset.row)
  end

  def application_check(full_api, expires)
    full_api && expires == nil
  end

  def alpha_check(expires)
    if expires < Time.now.utc
      true
    else
      false
    end
  end

  def get_characters_from_api_key_info(character_infos)
    characters = []
    if !character_infos.kind_of?(Array)
        info = character_infos
        c = Character.new
        c.character_id = info.characterID
        c.character_name = info.characterName
        c.corporation_id = info.corporationID
        c.corporation_name = info.corporationName
        c.alliance_id = info.allianceID
        c.alliance_name = info.allianceName
        characters << c
    else
      character_infos.each do |info|
        c = Character.new
        c.character_id = info["characterID"]
        c.character_name = info["characterName"]
        c.corporation_id = info["corporationID"]
        c.corporation_name = info["corporationName"]
        c.alliance_id = info["allianceID"]
        c.alliance_name = info["allianceName"]
        characters << c
      end
    end
    characters
  end

  def full_api?
    return false if !character_wallet_read
    return false if !character_assets_read
    return false if !character_calendar_read
    return false if !character_contacts_read
    return false if !character_factional_warfare_read
    return false if !character_industry_jobs_read
    return false if !character_kills_read
    return false if !character_mail_read
    return false if !character_market_orders_read
    return false if !character_medals_read
    return false if !character_notifications_read
    return false if !character_research_read
    return false if !character_skills_read
    return false if !character_account_read
    return false if !character_contracts_read
    return false if !character_bookmarks_read
    return false if !character_chat_channels_read
    return false if !character_clones_read
    return true
  end

  def character_wallet_read
    check_mask(1) || check_mask(2097152) || check_mask(4194304)
  end

  def character_assets_read
    check_mask(2) || check_mask(134217728)
  end

  def character_calendar_read
    check_mask(4) || check_mask(1048576)
  end

  def character_contacts_read
    check_mask(16) || check_mask(32) || check_mask(524288)
  end

  def character_factional_warfare_read
    check_mask(64)
  end

  def character_industry_jobs_read
    check_mask(128)
  end

  def character_kills_read
    check_mask(256)
  end

  def character_mail_read
    check_mask(512) || check_mask(1024) || check_mask(2048)
  end

  def character_market_orders_read
    check_mask(4096)
  end

  def character_medals_read
    check_mask(8192)
  end

  def character_notifications_read
    check_mask(16384) || check_mask(32768)
  end

  def character_research_read
    check_mask(65536)
  end

  def character_skills_read
    check_mask(131072) || check_mask(262144) || check_mask(1073741824)
  end

  def character_account_read
    check_mask(33554432)
  end

  def character_contracts_read
    check_mask(67108864)
  end

  def character_bookmarks_read
    check_mask(268435456)
  end

  def character_chat_channels_read
    check_mask(536870912)
  end

  def character_clones_read
    check_mask(2147483648)
  end

  def api_mask
    self.key_id = id_mask(self.key_id)
    self.v_code = id_mask(self.v_code)
  end

  private

  def id_mask(target)
    result = ""
    for i in 0..target.size
     if i < 3
       result += target[i]
     else
       result += "*"
     end
    end
    result
  end

  def check_mask(mask)
    ( self.access_mask | mask == self.access_mask)
  end
end
