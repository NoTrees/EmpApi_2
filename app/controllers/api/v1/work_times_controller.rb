module API::V1
  class WorkTimesController < VersionController

    #GET /work_times
    #GET /work_times.json
    def index
      @work_times = WorkTime.all

      if employee_id = params[:employee_id]
        @work_times = @work_times.where(employee_id: employee_id)
      end

      if work_date = params[:work_date]
        @work_times = @work_times.where(work_date: work_date)
      end      

      respond_to do |format|
        format.html { render "work_times/index", status: :ok }
        format.json { render json: @work_times, status: :ok }
        format.xml { render xml: @work_times, status: :ok }
      end
    end

    def show
      @work_time = WorkTime.find(params[:id])

      respond_to do |format|
        format.html { render "work_times/show", status: :ok }
        format.json { render json: @work_times, status: :ok }
        format.xml { render xml: @work_times, status: :ok }
      end
    end

    def new
      @work_time = WorkTime.new

      render "work_times/new"
    end

    #POST /work_time
    def create
      @work_time = WorkTime.new(work_time_params)
      if @work_time.save
        respond_to do |format|
          format.html { redirect_to work_times_path, notice: "work time created!" }
          format.json { render json: @work_time, status: :created, location: [ :api, @work_time ] }
          format.xml { render xml: @work_time, status: :created, location: [ :api, @work_time ] }
        end
      else
        respond_to do |format|
          format.html { redirect_to new_work_time_path, notice: @work_time.errors }
          format.json { render json: @work_time.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @work_time = WorkTime.find(params[:id])

      if @work_time.update(work_time_params)
        render json: @work_time, status: :ok
      else
        render json: @work_time.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @work_time = WorkTime.find(params[:id])
      @work_time.destroy
      head :no_content
    end

    private
      def work_time_params
        params.require(:work_time).permit(:employee_id, :time_of_scan, :time_flag, :work_date)
      end
  end
end