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

    def create
    end

    def update
    end

    def destroy
    end
  end
end