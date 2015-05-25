module API::V1
  class EmployeesController < VersionController

    #GET /employees
    #GET /employees.json
    def index
      @employees = Employee.all

      if division = params[:division]
        @employees = employees.where(division: division)
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
            format.html { redirect_to employees_path, status: :ok }
            format.json { render json: @employee, status: :created, location: [ :api, @employee ] }
            format.xml { render xml: @employee, status: :created, location: [ :api, @employee ] }
          end
      else
          respond_to do |format|
            format.html { redirect_to new_employee_path, notice: @employee.errors }
            format.json { render json: @employee.errors, status: :unprocessable_entity }
          end
      end
    end

    def update
      @employee = Employee.find(params[:id])

      if @employee.update(employee_params)
        render json: @employee, status: :ok
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @employee = Employee.find(params[:id])
      @employee.destroy
      head :no_content
    end

    private
      def employee_params
        params.require(:employee).permit(:id, :name, :division, :authentication, :address)
      end
  end
end