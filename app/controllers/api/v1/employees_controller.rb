module API::V1
  class EmployeesController < VersionController
    # checks if a user is logged in
    # actual logged_in_employee method is contained in the Version Controller under api folder and the appropriate version folder
    before_action :logged_in_employee
    # checks if the employee seeing certain information, like other profiles, is the employee itself
    # prevents employees from seeing other employees' information through fixing the URL
    # allows admin users to view everything though
    # correct_employee method present in this controller
    before_action :correct_employee

    # ROUTES: api/v1/employees#index
    # PATH:   api_employees
    #
    # shows all employees in the employee table
    #
    # NOTE: queries are case sensitive!
    #       looks for the exact match in the database as typed in the query!
    #       no search bar made for this
    #       not available for non-admin users
    def index
      @employees = Employee.all

      # below are filters for the employee list
      # header title is for the index views for each queries
      @header_title = "All Employees"
      # query for the employee's ID
      # filter list according to a specific employee ID
      if id = params[:id]
        @header_title = "All Employee with ID #{id}"
        @employees = @employees.where(id: id)
      end
      # query for the employee's name
      # filter list according to a specific employee name
      if name = params[:name]
        @header_title = "All Employees named #{name}"
        @employees = @employees.where(name: name)
      end
      # query for employee's division
      # filter list according to a specific employee division
      if division = params[:division]
        @header_title = "All Employees Under #{division} Division"
        @employees = @employees.where(division: division)
      end
      # query for the employee's WHOLE address
      # filter list according to a specific employee address
      if address = params[:address]
        @header_title = "All Employees with address #{address}"
        @employees = @employees.where(address: address)
      end
      # query for all admin employees
      # filter list according to employee admin priviledges
      # choices can only be "true" or "false"
      # NOTE: looks for values of is_admin in employee tables that equal true
      #       can only be seen by admin users
      if is_admin = params[:is_admin]
        @header_title = "All Admin Employees"
        @employees = @employees.where(is_admin: is_admin)
      end

      # renders the display according to what format the URL or request was in
      respond_to do |format|
        # HTML requests will render the index.html.erb present in app/views/employees folder
        # displays the list of employees in index.html.erb
        format.html { render "employees/index", status: :ok }
        # JSON requests will render the list of employees in json format
        format.json { render json: @employees, status: :ok }
        # XML requests will render the list of employees in xml format
        format.xml { render xml: @employees, status: :ok }
      end
    end

    # ROUTES: api/v1/employees#new
    # PATH: new_api_employee
    #
    # creates a new employee instance
    #
    # NOTE: not available for non-admin employees/users
    def new
      @employee = Employee.new

      # render the new.html.erb present in app/views/employee folder
      render "employees/new"
    end

    # ROUTES: api/v1/employees#show
    # PATH: api_employee
    #
    # show employee profile from the employee's ID
    #
    # NOTE: can only see own profile for non-admin users
    def show
      @employee = Employee.find(params[:id])

      # renders the display according to what format the URL or request was in
      respond_to do |format|
        # HTML requests will render the show.html.erb present in app/views/employees folder
        # displays the employee in show.html.erb
        format.html { render "employees/show", status: :ok }
        # JSON requests will render the employee profile in json format
        format.json { render json: @employee, status: :ok }
        # XML requests will render the employee profile in xml format
        format.xml { render xml: @employee, status: :ok }
      end
    end

    # ROUTES: api/v1/employees#create
    #
    # create the actual employee and save it into the employee table
    #
    # NOTE: not available for non-admin employees/users
    def create
      # makes an instance of Employee that accepts certain parameters given by employee_params method
      # method is present in this controller
      @employee = Employee.new(employee_params)

      # checks if the employee is successfully saved in the database
      if @employee.save
        # if saved successfully, controller issues a response according to the format given
        respond_to do |format|
          # HTML redirects the user back to employee index and makes a notice that creation was successful
          format.html { redirect_to api_employees_path, notice: "Successfully created employee!" }
          # JSON renders the employee made in JSON and gives the created status response
          format.json { render json: @employee, status: :created, location: [ :api, @employee ] }
          # XML renders the employee made in XML and gives the created status response
          format.xml { render xml: @employee, status: :created, location: [ :api, @employee ] }
        end
      else
        # if errors occured like wrong information/wrong format and so on, issues a response according to format
        respond_to do |format|
          # HTML redirects the user back to the employee creation page and shows a list of errors encountered
          format.html { redirect_to new_api_employee_path, notice: @employee.errors.full_messages }
          # JSON renders all errors made and shows it in JSON and gives a negative response
          format.json { render json: @employee.errors, status: :unprocessable_entity }
          # XML renders all errors made and shows it in XML and gives a negative response
          format.xml { render xml: @employee.errors, status: :unprocessable_entity }
        end
      end
    end

    # ROUTES: api/v1/employees#edit
    # PATH: edit_api_employee
    #
    # edit an existing employee profile
    #
    # NOTE: certain attributes cannot be edited by non-admin employees
    #       admins can edit all attributes as they see fit
    def edit
      @employee = Employee.find(params[:id])

      # render the edit.html.erb present in app/views/employee folder
      render "employees/edit"
    end

    # ROUTES: api/v1/employees#update
    #
    # edit an existing employee profile and save it to the table
    #
    # NOTE: certain attributes cannot be edited by non-admin employees
    #       admins can edit all attributes as they see fit
    def update
      @employee = Employee.find(params[:id])

      # checks if employee is successfully updated in the database
      if @employee.update(employee_params)
        # if updated successfully, controller issues a response according to the format given
        respond_to do |format|
          # HTML redirects the user back to employee's profile and makes a notice that editing was successful
          format.html { redirect_to api_employee_path, notice: "Successfully Edited Employee!" }
          # JSON renders the employee updated in JSON
          format.json { render json: @employee, status: :ok }
          # XML renders the employee updated in XML
          format.xml { render xml: @employee, status: :ok }
        end
      else
        # if errors occured like wrong information/wrong format and so on, issues a response according to format
        respond_to do |format|
          # HTML redirects the user back to the employee edit page and shows a list of errors encountered
          format.html { redirect_to edit_api_employee_path(@employee), notice: @employee.errors.full_messages }
          # JSON renders all errors made and shows it in JSON and gives a negative response
          format.json { render json: @employee.errors, status: :unprocessable_entity }
          # XML renders all errors made and shows it in XML and gives a negative response
          format.xml { render xml: @employee.errors, status: :unprocessable_entity }
        end
      end
    end

    # ROUTES: api/v1/employees#destroy
    #
    # delete an existing employee from database
    #
    # NOTE: can only be done by admins
    def destroy
      @employee = Employee.find(params[:id])
      @employee.destroy
      # after deleting, controller issues a response according to the format given
      respond_to do |format|
        # HTML redirects back to employee index and shows the notice
        format.html { redirect_to api_employees_path, notice: "Successfully deleted employee!" }
        # JSON will just give a deleted response
        format.json { head :no_content }
        # XML will just give a deleted response
        format.xml { head :no_content }
      end
    end

    private
      # method that sets the acceptable parameters the employee creation must get
      # attributes present in the parameters also present in Employee model
      # password and password confirmation is handled by by bcrypt gem? and used by the has_secure_password line in the employee model
      # attributes are as follows: id (employee's ID)
      #                            name (employee's name)
      #                            division (employee's division)
      #                            address (employee's address)
      #                            is_admin (admin privileges)
      #
      # validations made for those attributes are present in the employee model located in app/models folder
      def employee_params
        params.require(:employee).permit(:id, :name, :division, :address, :password, :password_confirmation, :is_admin)
      end

      # method for preventing employees from seeing other employees' information
      # checks if user currently logged in is the employee themselves or is an admin
      def correct_employee
        employee = Employee.find_by(id: params[:id])
        # redirects non-admin employee trying to see the other employee information to the home path/welcome page
        # also displays a notice "Can't do that!" once redirected
        redirect_to home_path, notice: "Can't do that!" unless ( employee == @current_user || admin_mode? )
      end
  end
end