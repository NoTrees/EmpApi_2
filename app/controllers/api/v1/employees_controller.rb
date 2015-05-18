module API::V1
  class EmployeesController < ApplicationController
    
    #GET /employees
    #GET /employees.json
    def index
      employees = Employee.all

      if division = params[:division]
        employees = employees.where(division: division)
      end

      respond_to do |format|
        format.json { render json: employees, status: :ok }
        format.xml { render xml: employees, status: :ok }
      end
    end

    #GET /employees/:id
    def show
      employee = Employee.find(params[:id])

      respond_to do |format|
        format.json { render json: employee, status: :ok }
        format.xml { render xml: employee, status: :ok }
      end
    end

    #POST /employees
    def create
      employee = Employee.new(employee_params)
      if employee.save
          render json: employee, status: :created, location: [ :api, :v1, employee ]
      else
          render json: employee.errors, status: :unprocessable_entity
      end
    end

    def update
      employee = Employee.find(params[:id])

      if employee.update(employee_params)
        render json: employee, status: :ok
      else
        render json: employee.errors, status: :unprocessable_entity
      end
    end

    def destroy
    end

    private
      def employee_params
        params.require(:employee).permit(:id, :name, :division, :authentication, :address)
      end
  end
end