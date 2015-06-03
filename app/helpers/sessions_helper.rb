module SessionsHelper
	def admin_mode(value = "false")
		$admin_mode = value
	end

	def admin_mode?
		$admin_mode == "true"
	end

	def log_in(employee)
		session[:id] = employee.id
	end

	def log_out
		session.delete(:id)
		@current_user = nil
		admin_mode(false)
	end

	def current_user
		@current_user ||= Employee.find_by(id: session[:id])
	end

	def logged_in?
		!current_user.nil?
	end
end
