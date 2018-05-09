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
end
