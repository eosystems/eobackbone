class Api::MyCorporationsController < ApiController
  def index
    @relation = CorporationRelation.relation_corporation(current_character.corporation_id)
    @corporations = Corporation.where(corporation_id: @relation)
    render json: { results: @corporations }
  end
end
