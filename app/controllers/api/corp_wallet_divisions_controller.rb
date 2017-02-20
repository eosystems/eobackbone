class Api::CorpWalletDivisionsController < ApiController
  def index
    @divisions = CorpWalletDivision
      .accessible_divisions(current_character.corporation_id)
      .order(id: :asc)
  end

end
