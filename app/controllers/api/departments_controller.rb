class Api::DepartmentsController < ApiController
  def index
    @departments = nil
    if current_user.has_manager_role?
      @departments = Department
        .accessible_departments(current_character.corporation_id)
        .order(id: :desc)
    end
  end

  def show
    @department = Department.find(params[:id])
  end

  def create
    if current_user.has_manager_role? == false
      render json: { error: "You don't have manager role" }, status: 500
    else
      @department = Department.new(department_params)
      @department.corporation_id = current_character.corporation_id
      if @department.save
        render json: { message: "success"}
      else
        render json: { error: "Something Wrong"}, status: 500
      end
    end
  end

  def update
    @department = Department.find(params[:id])
    @department.department_name = params[:department_name]
    if @department.save
      render json: {}
    else
      render json: { error: "something wrong" }
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    render json: {}
  end
  private

  def department_params
    params
      .require(:department)
      .permit(:department_name)
  end
end
