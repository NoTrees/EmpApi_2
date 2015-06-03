class SessionsController < ApplicationController
  def new
  end

  def create
  	employee = Employee.find_by(id: params[:session][:id])
  	if employee && employee.authenticate(params[:session][:password])
      if params[:commit] == "Log in!"
        log_in employee
        respond_to do |format|
          format.html { redirect_to home_path, notice: "Welcome #{current_user.name}!" }
        end
      else
        if employee.is_admin == "true"
          log_in employee
          admin_mode("true")
          respond_to do |format|
            format.html { redirect_to home_path, notice: "Welcome Admin #{current_user.name}!" }
          end
        else
          respond_to do |format|
            format.html { redirect_to login_path, notice: "Cannot login, not an admin!" }
          end
        end
      end
  	else
  		respond_to do |format|
  			format.html { redirect_to login_path, notice: "Wrong ID and Password combination!" }
  		end
  	end
  end

  def destroy
  	last_user = current_user.name
  	log_out
  	redirect_to login_path, notice: "#{last_user} has signed off!"
  end
end
