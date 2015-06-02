module API::V1
  class WorkTimesController < VersionController
    before_action :logged_in_employee, except: [:new, :create]
    before_action :correct_work_time, except: [:new, :create]

    #GET /work_times
    #GET /work_times.json
    def index
      @work_times = WorkTime.all
      @header_title = "All Employee"

      if id = params[:id]
        @header_title = ""
        @work_times = @work_times.where(id: id)
      end

      if employee_id = params[:employee_id]
        employee = Employee.find(employee_id)
        @header_title = "#{employee.name}'s"
        @work_times = @work_times.where(employee_id: employee_id)
      end

      if time_of_scan = params[:time_of_scan]
        @header_title = "All #{time_of_scan} timed"
        @work_times = @work_times.where(employee_id: employee_id)
      end            

      if time_flag = params[:time_flag]
        @header_title = "All #{employee.name}'s"
        @work_times = @work_times.where(employee_id: employee_id)
      end      

      if work_date = params[:work_date]
        @header_title = "All #{params[:work_date]} Dated"
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

      if current_user.nil? || current_user.is_admin == "true"
        respond_to do |format|
          format.html { render "work_times/new" }
        end
      else
        respond_to do |format|
          format.html { redirect_to home_path }
        end
      end
    end

    def show
      @work_time = WorkTime.find(params[:id])
      @employee = Employee.find(@work_time.employee_id)

      respond_to do |format|
        format.html { render "work_times/show", status: :ok }
        format.json { render json: @work_times, status: :ok }
        format.xml { render xml: @work_times, status: :ok }
      end
    end

    #POST /work_time
    def create
      employee = Employee.find_by(id: params[:work_time][:employee_id])
      @work_time = WorkTime.new(work_time_params)

      unless current_user.nil?
        if (employee && employee.authenticate(params[:work_time][:password])) || @current_user.is_admin == "true"
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
              format.html { redirect_to new_api_work_time_path, notice: @work_time.errors.full_messages }
              format.json { render json: @work_time.errors, status: :unprocessable_entity }
              format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
            end
          end
        else
          respond_to do |format|
            format.html { redirect_to new_api_work_time_path, notice: "Invalid ID and Password combination!" }
            format.json { render json: @work_time.errors, status: :unprocessable_entity }
            format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
          end
        end
      else
        if (employee && employee.authenticate(params[:work_time][:password]))
          if @work_time.save
            respond_to do |format|
              if params[:work_time][:time_flag] == "logged_in"
                format.html { redirect_to root_path, notice: "Work time created! Welcome #{employee.name}" }
              else
                format.html { redirect_to root_path, notice: "Work time created! Goodbye #{employee.name}" }
              end
              format.json { render json: @work_time, status: :created, location: [ :api, @work_time ] }
              format.xml { render xml: @work_time, status: :created, location: [ :api, @work_time ] }
            end
          else
            respond_to do |format|
              format.html { redirect_to root_path, notice: @work_time.errors.full_messages }
              format.json { render json: @work_time.errors, status: :unprocessable_entity }
              format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
            end
          end
        else
          respond_to do |format|
            format.html { redirect_to root_path, notice: "Invalid ID and Password combination!" }
            format.json { render json: @work_time.errors, status: :unprocessable_entity }
            format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
          end
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
          format.xml { render xml: @work_time, status: :ok }
        end
      else
        respond_to do |format|
          format.html { redirect_to new_api_work_time_path, notice: @work_times.errors.full_messages }
          format.json { render json: @work_time.errors, status: :unprocessable_entity }
          format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @work_time = WorkTime.find(params[:id])
      @work_time.destroy
      respond_to do |format|
        format.html { redirect_to api_work_times_path, notice: "Successfully deleted work time!" }
        format.json { head :no_content }
        format.xml { head :no_content }
      end
    end

    private
      def work_time_params
        params.require(:work_time).permit(:employee_id, :time_of_scan, :time_flag, :work_date)
      end

      def correct_work_time
        work_time = WorkTime.find_or_initialize_by(employee_id: params[:employee_id])
        redirect_to home_path, notice: "Can't do that!" unless ( work_time.employee_id == @current_user.id || current_user.is_admin == "true" )
      end
  end
end