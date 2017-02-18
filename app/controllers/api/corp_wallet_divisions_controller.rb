class Api::CorpWalletDivisionsController < ApiController
  def index
    @divisions = CorpWalletDivision
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .accessible_divisions(current_character.corporation_id)
      .order(id: :asc)
  end

end
