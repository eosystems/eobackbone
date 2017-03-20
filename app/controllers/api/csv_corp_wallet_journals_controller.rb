class Api::CsvCorpWalletJournalsController < ApiController
  def index
    @journals = CorpWalletJournal
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .accessible_orders(current_character.corporation_id)
      .includes(:corporation)
      .includes(:ref_type)
      .order(ref_id: :desc)

    respond_to do |format|
      format.csv { send_data CorpWalletJournal.to_csv(@journals) }
    end
  end

end
