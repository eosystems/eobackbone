class Api::CorpWalletDivisionsController < ApiController
  def index
    corp = params[:corporation_id]
    @divisions = CorpWalletDivision
      .accessible_divisions(current_character.corporation_id)
      .where(corporation_id: corp)
      .order(id: :asc)
  end

end
