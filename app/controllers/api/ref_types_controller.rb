class Api::RefTypesController < ApiController
  def index
    @types = RefType
      .order(name: :asc)
  end
end
