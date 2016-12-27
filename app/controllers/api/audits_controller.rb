class Api::AuditsController < ApiController
  def index
    @audits = nil
    if current_user.has_api_manager_role?
     @audits = Audit
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_audit(current_user.id)
        .order(id: :desc)
    end
    render json: {results: @audits}
  end

end
