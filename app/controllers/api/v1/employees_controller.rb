module API::V1
  class EmployeesController < ApplicationController
    
    #GET /employees
    #GET /employees.json
    def index
      employees = Employee.all

      if division = params[:division]
        employees = employees.where(division: division)
      end

      render json: employees, status: :ok
    end

    #GET /employees/:id
    def show
      employee = Employee.find(params[:id])
      render json: employee, status: :ok
    end

    def create
    end

    def update
    end

    def destroy
    end
  end
end