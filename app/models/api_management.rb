# == Schema Information
#
# Table name: api_managements
#
#  id                        :integer          not null, primary key
#  key_id                    :string(255)      not null
#  v_code                    :string(255)      not null
#  uid                       :string(255)      not null
#  character_id              :string(255)      not null
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
  belongs_to :corporation
  belongs_to :user, class_name: 'User', foreign_key: :uid

  attr_accessor :check_lists # APICheck結果

  # Scope
  # 指定したCorpに属している
  scope :accessible_api_management, -> (corporation_id) do
    cid = arel_table[:corporation_id]
    where(cid.eq(corporation_id))
  end

  # Methods

  def api_check(key_id, v_code)
    response = EveClient.new(key_id, v_code).fetch_api_key_info
    item = response.items[0].key
    self.access_mask = item.accessMask
    self.full_api = self.full_api?
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

  private

  def check_mask(mask)
    ( self.access_mask | mask == self.access_mask)
  end
end
