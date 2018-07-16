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

  # TODO
  def self.entry_corp_date(user_id, corporation_id)
    token = User.find_by(character_id: character_id)
    return nil if token.nil?

    Time.now
  end

  def self.title(character_id)
    user = User.find_by(uid: character_id)
    return nil if user.nil?

    token = User.user_token(user)
    return nil if token.nil?

    response = EsiClient.new(token).fetch_character_titles(character_id)
    if response.is_success
      response.items.map { |v| v["name"] }.join('|')
    else
      nil
    end
  end
end
