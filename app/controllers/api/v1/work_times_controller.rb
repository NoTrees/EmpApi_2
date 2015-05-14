module API::V1
  class WorkTimesController < ApplicationController
    
    #GET /work_times
    #GET /work_times.json
    def index
      work_times = WorkTime.all

      if employee_id = params[:employee_id]
        work_times = work_times.where(employee_id: employee_id)
      end

      if work_date = params[:work_date]
        work_times = work_times.where(work_date: work_date)
      end      

      respond_to do |format|
        format.json { render json: work_times, status: :ok }
        format.xml { render xml: work_times, status: :ok }
      end
    end

    def show
    end

    def create
    end

    def update
    end

    def destroy
    end
  end
end