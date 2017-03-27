class Api::CsvCorpWalletJournalsController < ApiController
  def index
    @journals = CorpWalletJournal
      .accessible_orders(current_character.corporation_id)
      .where(
    corporation_id: params[:corporation_id],
    corp_wallet_division_id: params[:corp_wallet_division_id],
    i_date: params[:from_i_date]..params[:to_i_date]
    )
      .includes(:corporation)
      .includes(:ref_type)
      .order(ref_id: :desc)
  end

end
