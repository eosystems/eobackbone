class Api::CorpWalletJournalsController < ApiController
  def index
    @journals = CorpWalletJournal
      .accessible_orders(current_character.corporation_id, current_user.id)
      .order(ref_id: :desc)
  end

end
