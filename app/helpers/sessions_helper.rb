module SessionsHelper
	
	# sets admin mode variable to a certain value
	# used to see if user logs in as an admin or not
	# default value is always false
	def admin_session(value = "false")
		session[:admin_session] = value
	end

	# checks and returns a boolean value if admin mode is enabled or not
	def admin_mode?
		session[:admin_session] == "true"
	end

	# sets the current session ID to the employee's ID
	def log_in(employee)
		session[:id] = employee.id
	end

	# deletes the current session
	# makes the current user to nil
	# makes admin mode to false
	def log_out
		session.delete(:id)
		@current_user = nil
		admin_session(false)
	end

	# current user is set as the employee who logged in
	# find employee in employee tables via the ID provided
	def current_user
		@current_user ||= Employee.find_by(id: session[:id])
	end

	# checks if there are users logged in
	def logged_in?
		!current_user.nil?
	end
end
