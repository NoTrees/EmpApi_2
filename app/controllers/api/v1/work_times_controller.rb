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

    def new
      @work_time = WorkTime.new

      render "work_times/new"
    end

    def show
      @work_time = WorkTime.find(params[:id])

      respond_to do |format|
        if @current_user.is_admin == "true"
          format.html { render "work_times/show", status: :ok }
          format.json { render json: @work_times, status: :ok }
          format.xml { render xml: @work_times, status: :ok }
        else
          format.html { redirect_to root_path, notice: "Can't do that! Not an Admin" }
        end
      end
    end

    #POST /work_time
    def create
      @work_time = WorkTime.new(work_time_params)
      if @work_time.save
        respond_to do |format|
          if current_user.is_admin == "true"
            format.html { redirect_to api_work_times_path, notice: "work time created!" }  
          else
            format.html { redirect_to api_work_times_path(employee_id: @current_user.id), notice: "work time created!" }
          end
          format.json { render json: @work_time, status: :created, location: [ :api, @work_time ] }
          format.xml { render xml: @work_time, status: :created, location: [ :api, @work_time ] }
        end
      else
        respond_to do |format|
          format.html { redirect_to new_api_work_time_path, notice: @work_time.errors }
          format.json { render json: @work_time.errors, status: :unprocessable_entity }
        end
      end
    end

    def edit
      @work_time = WorkTime.find(params[:id])

      render "work_times/edit"
    end

    def update
      @work_time = WorkTime.find(params[:id])

      if @work_time.update(work_time_params)
        respond_to do |format|
          format.html { redirect_to api_work_time_path, notice: "Successfully edited work time!" }
          format.json { render json: @work_time, status: :ok }
        end
      else
        respond_to do |format|
          format.html { redirect_to new_api_work_time_path, notice: @work_times.errors }
          format.json { render json: @work_time.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @work_time = WorkTime.find(params[:id])
      @work_time.destroy
      respond_to do |format|
        format.html { redirect_to api_work_times_path, notice: "Successfully deleted work time!" }
        format.json { head :no_content }
      end
    end

    private
      def work_time_params
        params.require(:work_time).permit(:employee_id, :time_of_scan, :time_flag, :work_date)
      end
  end
end