module API::V1
  class EmployeesController < VersionController
    before_action :logged_in_employee
    before_action :correct_employee

    #GET /employees
    #GET /employees.json
    def index
      @employees = Employee.all
      @header_title = "All Employees"

      if id = params[:id]
        @header_title = "All Employee with ID #{id}"
        @employees = @employees.where(id: id)
      end

      if name = params[:name]
        @header_title = "All Employees named #{name}"
        @employees = @employees.where(name: name)
      end

      if division = params[:division]
        @header_title = "All Employees Under #{division} Division"
        @employees = @employees.where(division: division)
      end

      if address = params[:address]
        @header_title = "All Employees with address #{address}"
        @employees = @employees.where(address: address)
      end

      if is_admin = params[:is_admin]
        @header_title = "All Admin Employees"
        @employees = @employees.where(is_admin: is_admin)
      end

      respond_to do |format|
        format.html { render "employees/index", status: :ok }
        format.json { render json: @employees, status: :ok }
        format.xml { render xml: @employees, status: :ok }
      end
    end

    def new
      @employee = Employee.new

      render "employees/new"
    end

    #GET /employees/:id
    def show
      @employee = Employee.find(params[:id])

      respond_to do |format|
        format.html { render "employees/show", status: :ok }
        format.json { render json: @employee, status: :ok }
        format.xml { render xml: @employee, status: :ok }
      end
    end

    #POST /employees
    def create
      @employee = Employee.new(employee_params)
      if @employee.save
          respond_to do |format|
            format.html { redirect_to api_employees_path, notice: "Successfully created employee!" }
            format.json { render json: @employee, status: :created, location: [ :api, @employee ] }
            format.xml { render xml: @employee, status: :created, location: [ :api, @employee ] }
          end
      else
          respond_to do |format|
            format.html { redirect_to new_api_employee_path, notice: @employee.errors.full_messages }
            format.json { render json: @employee.errors, status: :unprocessable_entity }
            format.xml { render xml: @employee.errors, status: :unprocessable_entity }
          end
      end
    end

    def edit
      @employee = Employee.find(params[:id])

      render "employees/edit"
    end

    def update
      @employee = Employee.find(params[:id])

      if @employee.update(employee_params)
        respond_to do |format|
          format.html { redirect_to api_employee_path, notice: "Successfully Edited Employee!" }
          format.json { render json: @employee, status: :ok }
          format.xml { render xml: @employee, status: :ok }
        end
      else
        respond_to do |format|
          format.html { redirect_to edit_api_employee_path(@employee), notice: @employee.errors.full_messages }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
          format.xml { render xml: @employee.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @employee = Employee.find(params[:id])
      @employee.destroy
      respond_to do |format|
        format.html { redirect_to api_employees_path, notice: "Successfully deleted employee!" }
        format.json { head :no_content }
        format.xml { head :no_content }
      end
    end

    private
      def employee_params
        params.require(:employee).permit(:id, :name, :division, :address, :password, :password_confirmation, :is_admin)
      end

      def correct_employee
        employee = Employee.find_by(id: params[:id])
        redirect_to home_path, notice: "Can't do that!" unless ( employee == @current_user || admin_mode? )
      end
  end
end