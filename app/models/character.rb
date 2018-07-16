class Character
  include ActiveModel::Model

  EVE_CHAR_API_PATH = "https://esi.evetech.net/latest/characters/%d/".freeze

  attr_accessor *%i(
    character_id character_name corporation_id corporation_name alliance_id alliance_name
  )


  def self.initialized_by(token, account_id)
    account = token.get(EVE_CHAR_API_PATH % account_id)
    result = JSON.parse(account.body)
    Character.new.tap do |c|
      c.character_id = account_id
      c.character_name = result["name"]
      c.corporation_id = result["corporation_id"] if result["corporation_id"].present?
      # TODO
      #c.corporation_name = result["corporation"] if result["corporation"].present?
      c.alliance_id = result["alliance_id"] if result["alliance_id"].present?
      #c.alliance_name = result["alliance"] if result["alliance"].present?
    end
  end

  def self.info(character_id)
    response = EsiClient.new('').fetch_character(character_id)
    if response.is_success
      response.items[0]
    else
      nil
    end
  end

  def self.entry_corp_date(character_id, corporation_id)
    user = User.find_by(uid: character_id)
    return nil if user.nil?

    token = User.user_token(user)
    return nil if token.nil?

    response = EsiClient.new(token).fetch_character_corporation_history(character_id)
    if response.is_success
      entry_date = nil
      response.items.each do |i|
        if corporation_id == i["corporation_id"]
          if entry_date.nil? || entry_date > i["start_date"].to_date
            entry_date = i["start_date"].to_date
          end
        end
      end
      entry_date
    else
      nil
    end
  end

  def self.title(character_id)
    user = User.find_by(uid: character_id)
    return nil if user.nil?

    token = User.user_token(user)
    return nil if token.nil?

    response = EsiClient.new(token).fetch_character_titles(character_id)
    if response.is_success
      title = response.items.map { |v| v["name"] }.join('|')
      title = '' if title.nil?
      title
    else
      nil
    end
  end
end
