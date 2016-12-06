object false

child @check => :results do
  attributes :access_mask, :full_api

  child :check_detail do
    node(:character_wallet_read) { |o| o.character_wallet_read }
    node(:character_assets_read) { |o| o.character_assets_read }
    node(:character_calender_read) { |o| o.character_calender_read }
    node(:character_contacts_read) { |o| o.character_contacts_read }
    node(:character_factional_warfare_read) { |o| o.character_factional_warfare_read }
    node(:character_industry_jobs_read) { |o| o.character_industry_jobs_read }
    node(:character_kills_read) { |o| o.character_kills_read }
    node(:character_mail_read) { |o| o.character_mail_read }
    node(:character_market_orders_read) { |o| o.character_market_orders_read }
    node(:character_medals_read) { |o| o.character_medals_read }
    node(:character_notifications_read) { |o| o.character_notifications_read }
    node(:character_research_read) { |o| o.character_research_read }
    node(:character_skills_read) { |o| o.character_skills_read }
    node(:character_account_read) { |o| o.character_account_read }
    node(:character_contracts_read) { |o| o.character_contracts_read }
    node(:character_bookmarks_read) { |o| o.character_bookmarks_read }
    node(:character_chat_channels_read) { |o| o.character_chat_channels_read }
    node(:character_clones_read) { |o| o.character_clones_read }
  end

end
