class Character
  include ActiveModel::Model

  EVE_CHAR_API_PATH = "https://api.eveonline.com/eve/CharacterInfo.xml.aspx?characterID=%d".freeze

  attr_accessor *%i(
    character_id character_name corporation_id corporation_name alliance_id alliance_name
  )


  def self.initialized_by(token, account_id)
    account = token.get(EVE_CHAR_API_PATH % account_id)
    result = Hash.from_xml(account.body)["eveapi"]["result"]
    Character.new.tap do |c|
      c.character_id = result["characterID"]
      c.character_name = result["characterName"]
      c.corporation_id = result["corporationID"] if result["corporationID"].present?
      c.corporation_name = result["corporation"] if result["corporation"].present?
      c.alliance_id = result["allianceID"] if result["allianceID"].present?
      c.alliance_name = result["alliance"] if result["alliance"].present?
    end
  end
end
