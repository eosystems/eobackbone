class Api::ApiChecksController < ApiController

  def show
    @check = ApiManagement.new
    @check.api_check(params[:key_id], params[:v_code])
  end

 end
