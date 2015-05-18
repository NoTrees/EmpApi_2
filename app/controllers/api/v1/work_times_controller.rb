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
      work_time = WorkTime.find(params[:id])
      render json: work_time, status: :ok
    end

    #POST /work_time
    def create
      work_time = WorkTime.new(work_time_params)
      if work_time.save
        render json: work_time, status: :created, location: [ :api, :v1, work_time ]
      else
        render json: work_time.errors, status: :unprocessable_entity
      end
    end

    def update
      work_time = WorkTime.find(params[:id])

      if work_time.update(work_time_params)
        render json: work_time, status: :ok
      end
    end

    def destroy
    end

    private
      def work_time_params
        params.require(:work_time).permit(:employee_id, :time_of_scan, :time_flag, :work_date)
      end
  end
end