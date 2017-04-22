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

  # Hook
  after_create :audit_api_create
  after_destroy :audit_api_destroy

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

    # コープ情報がない場合は格納する
    self.characters.each do |c|
      corp = Corporation.new({corporation_name: c.corporation_name, corporation_id: c.corporation_id})
      corp.save if !corp.exists_corp?
    end
  end

  def self.all_api_update(dry_run: false)
    api_managements = ApiManagement.all
    api_managements.each do |api_management|
      api_management.api_update(dry_run: dry_run)
    end
  end

  def api_update(dry_run: false)
    client = EveClient.new(key_id, v_code)
    response = client.fetch_api_key_info
    if response.is_success
      response_account_status = client.fetch_account_status
      item = response.items[0].key

      after_characters = get_characters_from_api_key_info(item.rowset.row)
      exist_character = character_exist_check(after_characters)

      diff = false
      log_messages = ""
      if exist_character
        # Diff Check
        before_access_mask = self.access_mask
        before_expires = self.expires
        before_alpha = self.alpha
        before_full_api = self.full_api

        after_access_mask = item.accessMask
        after_expires = item.expires
        after_alpha = self.alpha_check(response_account_status.items[0].paidUntil)
        after_full_api = self.full_api?

        if before_access_mask.to_s != after_access_mask.to_s
          log_messages << "access_mask before:#{before_access_mask} after:#{after_access_mask} "
        end
        if before_expires.to_s != after_expires.to_s
          log_messages << "expires before:#{before_expires} after:#{after_expires} "
        end
        if before_alpha != after_alpha
          log_messages << "alpha before:#{before_alpha} after:#{after_alpha}"
        end
        if before_full_api != after_full_api
          log_messages << "full_api before:#{before_full_api} after:#{after_full_api}"
        end

        diff = true if log_messages != ""
        if diff
          log_messages = "System Api Update , Target key_id=#{key_id},character_name=#{self.character_name} . because " + log_messages

          if !dry_run
            # コープ情報がない場合は格納する
            after_characters.each do |c|
              corp = Corporation.new({corporation_name: c.corporation_name, corporation_id: c.corporation_id})
              corp.save if !corp.exists_corp?
            end
            self.access_mask = item.accessMask
            self.expires = item.expires
            self.alpha = self.alpha_check(response_account_status.items[0].paidUntil)
            self.full_api = self.full_api?
            self.all_check = application_check(self.full_api, self.expires)

            self.save!
            audit_api_update(log_messages)
            Rails.logger.info(log_messages)
          else
            Rails.logger.info("dry_run:" + log_messages)
          end
        else
          Rails.logger.info("api not update: character_name=#{self.character_name}")
        end
      else
        log_messages = "api update error: character_name=#{self.character_name} is not found this api.Check user and update or delete this api"
        audit_api_update(log_messages) unless dry_run
        Rails.logger.warn(log_messages)
      end
    else
      log_messages = "api update error because this api user change access mask? Check User and delete this api."
      log_messages << "Detail: key_id=#{key_id},character_name=#{self.character_name}"
      audit_api_update(log_messages) unless dry_run
      Rails.logger.warn(log_messages)
    end

  end

  def character_exist_check(characters)
    exist_character = false
    characters.each do |character|
      if character.character_name == character_name
        exist_character = true
      end
    end
    exist_character
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

  # Audit Log
  def audit_api_create
    user = User.find(self.uid)
    audit = Audit.create({
      audit_type: "APIManagement",
      audit_text: user.name + " created api, key_id:" + self.key_id +
      ", character_name: " + self.character_name,
      corporation_id: user.user_detail.corporation_id,
      uid: user.id
    })
    audit.save!
  end

  def audit_api_update(message)
    user = User.find(self.uid)
    audit = Audit.create({
      audit_type: "APIManagement",
      audit_text: message,
      corporation_id: user.user_detail.corporation_id,
      uid: user.id
    })
    audit.save!
  end

  def audit_api_destroy
    user = User.find(self.uid)
    audit = Audit.create({
      audit_type: "APIManagement",
      audit_text: user.name + " deleted api, key_id:" + self.key_id.to_s +
      ", character_name: " + self.character_name,
      corporation_id: user.user_detail.corporation_id,
      uid: user.id
    })
    audit.save!
  end

end
