module API::V1
  class WorkTimesController < VersionController
    # checks if a user is logged in
    # actual logged_in_employee method is contained in the Version Controller under api folder and the appropriate version folder
    #
    # NOTE: even if a user is not logged in, creating a new work time is permitted as given by the except clause
    before_action :logged_in_employee, except: [:new, :create]
    # checks if the employee seeing certain information, like other employee work times, is the employee itself
    # prevents employees from seeing other employees' information through fixing the URL
    # allows admin users to view everything though
    # correct_work_time method present in this controller
    #
    # NOTE: creating a new work time is permitted to anyone as given by the except clause
    before_action :correct_work_time, except: [:new, :create]

    # ROUTES: api/v1/work_times#index
    # PATH:   api_work_times
    #
    # shows all work times in the work time table
    #
    # NOTE: queries are case sensitive!
    #       looks for the exact match in the database as typed in the query!
    #       no search bar made for this
    #       can only see own work times for non-admin employees
    def index
      @work_times = WorkTime.all

      # below are filters for the employee list
      # header title is for the index views for each queries
      @header_title = "All Employee"
      # query for the work time ID
      # filter list according to a specific work time ID
      # id is usually given by default in rails andis used mainly in the show method
      if id = params[:id]
        @header_title = ""
        @work_times = @work_times.where(id: id)
      end
      # query for work time under a certain employee through their employee ID
      # filter list according to employee ID
      if employee_id = params[:employee_id]
        employee = Employee.find(employee_id)
        @header_title = "#{employee.name}'s"
        @work_times = @work_times.where(employee_id: employee_id)
      end
      # query for work time of a specific time of scan
      # filter list according to the time the work time had been scanned or made
      # must input until the last second
      # format: HH:MM:SS
      if time_of_scan = params[:time_of_scan]
        @header_title = "All #{time_of_scan} timed"
        @work_times = @work_times.where(employee_id: employee_id)
      end            
      # query for time flag of work times
      # filter list according to what is logged in or what is logged out in the table
      # only two choices must be "logged_in" or "logged_out" else it will return nothing
      if time_flag = params[:time_flag]
        @header_title = "All #{employee.name}'s"
        @work_times = @work_times.where(employee_id: employee_id)
      end      
      # query for the date of the work time
      # filter list according to the date of creation of the work time
      # format: YYYY-MM-DD
      if work_date = params[:work_date]
        @header_title = "All #{params[:work_date]} Dated"
        @work_times = @work_times.where(work_date: work_date)
      end      

      # renders the display according to what format the URL or request was in
      respond_to do |format|
        # HTML requests will render the index.html.erb present in app/views/work_times folder
        # displays the list of work times in index.html.erb
        format.html { render "work_times/index", status: :ok }
        # JSON requests will render the list of work times in json format
        format.json { render json: @work_times, status: :ok }
        # XML requests will render the list of work times in xml format
        format.xml { render xml: @work_times, status: :ok }
      end
    end

    # ROUTES: api/v1/work_times#new
    # PATH: new_api_work_time
    #
    # creates a new work time instance
    #
    # NOTE: available for non-admin employees/users and admins
    #       non-admin employees cannot create work times when they are logged in
    def new
      @work_time = WorkTime.new

      # checks if no one is logged in or an admin is logged in
      if current_user.nil? || admin_mode?
        # if so, method renders new.html.erb view present in app/views/work_times
        render "work_times/new"
      else
        # else, method redirects the employee back to the home page
        redirect_to home_path, notice: "Can't do that! Log out to make a new work time!"
      end
    end

    # ROUTES: api/v1/work_times#show
    # PATH: api_work_time
    #
    # show a single work time from the work time's id
    #
    # NOTE: not available for non-admin users
    def show
      @work_time = WorkTime.find(params[:id])
      # search for employee for the header of the work time view in show.html.erb
      # makes use of the employee ID present in the current work time being seen
      @employee = Employee.find(@work_time.employee_id)

      # renders the display according to what format the URL or request was in
      respond_to do |format|
        # HTML requests will render the show.html.erb present in app/views/work_times folder
        # displays the work time in show.html.erb
        format.html { render "work_times/show", status: :ok }
        # JSON requests will render the employee profile in json format
        format.json { render json: @work_times, status: :ok }
        # XML requests will render the employee profile in xml format
        format.xml { render xml: @work_times, status: :ok }
      end
    end

    # ROUTES: api/v1/work_times#create
    #
    # create the actual work time and save it into the work time table
    #
    # NOTE: available for non-admin employees/users and admins
    #       non-admin employees cannot create work times when they are logged in
    #       makes use of password authentication when creating a new work time
    #       logged in admins do not need to make use of password when making work times
    def create
      # employee is searched to match the authentication used to make the work time
      # did so to ensure that only the permitted people make work times
      employee = Employee.find_by(id: params[:work_time][:employee_id])
      @work_time = WorkTime.new(work_time_params)

      # check if there is an employee logged in
      unless current_user.nil?
        # if there is, checks if the user is an admin
        if admin_mode?
          # if the user is an admin, check if the work time is saved
          if @work_time.save
            # if saved successfully, controller issues a response according to the format given
            respond_to do |format|
              # HTML, controller redirects user back to the work time index and makes a notice
              format.html { redirect_to api_work_times_path, notice: "work time created!" }
              # JSON renders the work time made and gives the created status response
              format.json { render json: @work_time, status: :created, location: [ :api, @work_time ] }
              # XML renders the work time made in XML and gives the created status response
              format.xml { render xml: @work_time, status: :created, location: [ :api, @work_time ] }
            end
          else
            # if errors occured like wrong information/wrong format and so on, issues a response according to format
            respond_to do |format|
              # HTML redirects back to the work time creation page and shows the errors encountered
              format.html { redirect_to new_api_work_time_path, notice: @work_time.errors.full_messages }
              # JSON renders the errors encountered in JSON and give a negative response
              format.json { render json: @work_time.errors, status: :unprocessable_entity }
              # XML renders the errors encountered in XML and give a negative response
              format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
            end
          end
        else
          # if the user is not an admin, controller issues a response according to format
          respond_to do |format|
            # HTML redirects back to the work time creation page and show the notice
            format.html { redirect_to new_api_work_time_path, notice: "Can't do that! Admins only" }
            # JSON renders the errors encountered in JSON and give a negative response
            format.json { render json: @work_time.errors, status: :unprocessable_entity }
            # XML renders the errors encountered in XML and give a negative response
            format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
          end
        end
      else
        # if no users are logged in, checks if entered employee ID and password match
        if (employee && employee.authenticate(params[:work_time][:password]))
          # checks if the work time is saved successfully
          if @work_time.save
            # if saved successfully, controller issues a response according to the format given
            respond_to do |format|
              # for HTML, checks if if the work time done is a time in/log in by the employee
              if params[:work_time][:time_flag] == "logged_in"
                # if it is a log in, it redirects back to the work time creation page and gives a welcome notice
                format.html { redirect_to root_path, notice: "Work time created! Welcome #{employee.name}" }
              else
                # else, it redirects back to the work time creation page and gives a goodbye notice
                format.html { redirect_to root_path, notice: "Work time created! Goodbye #{employee.name}" }
              end
              # JSON renders the work time made and gives the created status response
              format.json { render json: @work_time, status: :created, location: [ :api, @work_time ] }
              # XML renders the work time made and gives the created status response
              format.xml { render xml: @work_time, status: :created, location: [ :api, @work_time ] }
            end
          else
            # if errors occured like wrong information/wrong format and so on, issues a response according to format
            respond_to do |format|
              # HTML redirects back to the work time creation page and shows the errors encountered
              format.html { redirect_to root_path, notice: @work_time.errors.full_messages }
              # JSON renders the errors encountered in JSON and give a negative response
              format.json { render json: @work_time.errors, status: :unprocessable_entity }
              # XML renders the errors encountered in XML and give a negative response
              format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
            end
          end
        else
          # if employee ID and password do not match, issues a response according to format
          respond_to do |format|
            # HTML redirects back to the work time creation page and shows the notice
            format.html { redirect_to root_path, notice: "Invalid ID and Password combination!" }
            # JSON renders the errors encountered in JSON and give a negative response
            format.json { render json: @work_time.errors, status: :unprocessable_entity }
            # XML renders the errors encountered in XML and give a negative response
            format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
          end
        end
      end
    end

    # ROUTES: api/v1/work_times#edit
    # PATH: edit_api_work_time
    #
    # edit an existing work time
    #
    # NOTE: not available for non-admin employees
    def edit
      @work_time = WorkTime.find(params[:id])

      # render the edit.html.erb present in app/views/work_times folder
      render "work_times/edit"
    end

    # ROUTES: api/v1/work_times#update
    #
    # edit an existing work time and save it to the table
    #
    # NOTE: not available for non-admin users
    def update
      @work_time = WorkTime.find(params[:id])

      # checks if work time is successfully updated in the database
      if @work_time.update(work_time_params)
        # if updated successfully, controller issues a response according to the format given
        respond_to do |format|
          # HTML redirects the user back to the work time index and makes a notice that editing was successful
          format.html { redirect_to api_work_time_path, notice: "Successfully edited work time!" }
          # JSON renders the work time updated in JSON
          format.json { render json: @work_time, status: :ok }
          # XML renders the work time updated in XML
          format.xml { render xml: @work_time, status: :ok }
        end
      else
        # if errors occured like wrong information/wrong format and so on, issues a response according to format
        respond_to do |format|
          # HTML redirects the user back to the work time edit page and shows a list of errors encountered
          format.html { redirect_to edit_api_work_time_path, notice: @work_times.errors.full_messages }
          # JSON renders all errors made and shows it in JSON and gives a negative response
          format.json { render json: @work_time.errors, status: :unprocessable_entity }
          # XML renders all errors made and shows it in XML and gives a negative response
          format.xml { render xml: @work_time.errors, status: :unprocessable_entity }
        end
      end
    end

    # ROUTES: api/v1/work_times#destroy
    #
    # delete an existing work from database
    #
    # NOTE: can only be done by admins
    def destroy
      @work_time = WorkTime.find(params[:id])
      @work_time.destroy
      # after deleting, controller issues a response according to the format given
      respond_to do |format|
        # HTML redirects back to work time index and shows the notice
        format.html { redirect_to api_work_times_path, notice: "Successfully deleted work time!" }
        # JSON will just give a deleted response
        format.json { head :no_content }
        # XML will just give a deleted response
        format.xml { head :no_content }
      end
    end

    private
      # method that sets the acceptable parameters the employee creation must get
      # attributes present in the parameters also present in Work Time model
      # attributes are as follows: employee_id (employee's ID)
      #                            time_of_scan (time the work time was made)
      #                            time_flag (timed in(logged_in) or timed out(logged_out))
      #                            work_date (date the work time was made)
      #
      # validations made for those attributes are present in the work time model located in app/models folder
      def work_time_params
        params.require(:work_time).permit(:employee_id, :time_of_scan, :time_flag, :work_date)
      end

      # method for preventing employees from seeing other employees' information
      # checks if user is going through someone else' records or not by finding the ID match with the employee ID present in the work time
      def correct_work_time
        work_time = WorkTime.find_or_initialize_by(employee_id: params[:employee_id])
        # redirects non-admin employee trying to see the other employee information to the home path/welcome page
        # also displays a notice "Can't do that!" once redirected
        redirect_to home_path, notice: "Can't do that!" unless ( work_time.employee_id == @current_user.id || admin_mode? )
      end
  end
end