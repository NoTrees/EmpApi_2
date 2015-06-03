class SessionsController < ApplicationController
  
  # ROUTE: sessions#new
  # PATH:  login
  #
  # creates a new session instance
  def new
  end

  # ROUTE: sessions#create
  #
  # creates and saves a session done/logs in a user
  def create
    # find the employee via the ID given by the user in log in
  	employee = Employee.find_by(id: params[:session][:id])
    # checks if the employee ID and password match
  	if employee && employee.authenticate(params[:session][:password])
      # checks if the user clicked on the basic login
      if params[:commit] == "Log in!"
        # logs in employee in the employee interface
        # log_in method is in sessions helper in app/helpers
        log_in employee
        respond_to do |format|
          # HTML redirects to home page and gives a welcome notice
          format.html { redirect_to home_path, notice: "Welcome #{current_user.name}!" }
        end
      # otherwise, user clicked on the admin login
      else
        # checks first if the user actually has admin priviledges
        if employee.is_admin == "true"
          # if so, logs the employee in
          # log_in method is in sessions helper in app/helpers
          log_in employee
          # makes so that the admin is logging in by making the session an admin session
          # admin_mode is in sessions helper in app/helpers
          admin_mode("true")
          respond_to do |format|
            # HTML redirects to home page and gives a welcome notice
            format.html { redirect_to home_path, notice: "Welcome Admin #{current_user.name}!" }
          end
        else
          # if the user is not an admin, a response is made
          respond_to do |format|
            # HTML redirects the user back to the log in page and gives a warning notice
            format.html { redirect_to login_path, notice: "Cannot login, not an admin!" }
          end
        end
      end
  	else
      # if the employee ID and password do not match, a response is made
  		respond_to do |format|
        # HTML redirects the user back to the log in page and gives a warning notice
  			format.html { redirect_to login_path, notice: "Wrong ID and Password combination!" }
  		end
  	end
  end

  # ROUTE: sessions#destroy
  # PATH:  logout
  #
  # deletes an existing session/logs out a user
  def destroy
  	last_user = current_user.name
    # sets the current user to nil and admin mode to false
    # log_out is in sessions helper in app/helpers
  	log_out
    # redirects to log in page once the user logs out
  	redirect_to login_path, notice: "#{last_user} has signed off!"
  end
end
