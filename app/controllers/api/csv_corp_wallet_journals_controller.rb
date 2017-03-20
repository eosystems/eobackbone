class Api::CsvCorpWalletJournalsController < ApiController
  def index
    @journals = CorpWalletJournal
      .accessible_orders(current_character.corporation_id)
      .includes(:corporation)
      .includes(:ref_type)
      .order(ref_id: :desc)
  end

end
