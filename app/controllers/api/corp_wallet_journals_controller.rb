class Api::CorpWalletJournalsController < ApiController
  def index
    @journals = CorpWalletJournal
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .accessible_orders(current_character.corporation_id)
      .includes(:corporation)
      .includes(:ref_type)
      .order(ref_id: :desc)
  end

  def update
    if current_user.has_contract_role?
      @journal = CorpWalletJournal.find(params[:id])
      if @journal.update(journal_params)
        render json: {}
      else
        render json: { error: "somthing wrong" }
      end
    else
      render json: { error: "You don't have contract role" }, status: 500
    end
  end

  private
  def journal_params
    params.permit(:ignore)
  end
end
