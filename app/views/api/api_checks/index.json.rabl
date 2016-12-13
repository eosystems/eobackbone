object false

child @check => :results do
  attributes :access_mask, :full_api, :expires, :alpha

  child :check_detail do
    node(:character_wallet_read) { @check.character_wallet_read }
    node(:character_assets_read) { @check.character_assets_read }
    node(:character_calendar_read) { @check.character_calendar_read }
    node(:character_contacts_read) { @check.character_contacts_read }
    node(:character_factional_warfare_read) { @check.character_factional_warfare_read }
    node(:character_industry_jobs_read) { @check.character_industry_jobs_read }
    node(:character_kills_read) { @check.character_kills_read }
    node(:character_mail_read) { @check.character_mail_read }
    node(:character_market_orders_read) { @check.character_market_orders_read }
    node(:character_medals_read) { @check.character_medals_read }
    node(:character_notifications_read) { @check.character_notifications_read }
    node(:character_research_read) { @check.character_research_read }
    node(:character_skills_read) { @check.character_skills_read }
    node(:character_account_read) { @check.character_account_read }
    node(:character_contracts_read) { @check.character_contracts_read }
    node(:character_bookmarks_read) { @check.character_bookmarks_read }
    node(:character_chat_channels_read) { @check.character_chat_channels_read }
    node(:character_clones_read) { @check.character_clones_read }
  end

end
