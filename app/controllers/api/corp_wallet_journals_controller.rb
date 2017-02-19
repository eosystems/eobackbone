class Api::CorpWalletJournalsController < ApiController
  def index
    @journals = CorpWalletJournal
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .accessible_orders(current_character.corporation_id)
      .includes(:corporation)
      .order(ref_id: :desc)
  end

end
