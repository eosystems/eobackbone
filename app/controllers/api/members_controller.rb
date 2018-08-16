class Api::MembersController < ApiController
  def index
    if params[:keyword].present?
      @members = CorpMember
        .search({ character_name_cont_all: params[:keyword].split(" ") })
        .result
        .limit(5)
      render json: { results: @members }
    else
      render json: { results: [] }
    end
  end
end
