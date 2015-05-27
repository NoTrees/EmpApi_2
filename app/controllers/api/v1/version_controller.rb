module API::V1
	class VersionController < ApplicationController
		abstract!

		before_action :set_api_version
		before_action :logged_in_employee

		private
			def logged_in_employee
				unless logged_in?
					respond_to do |format|
						format.html { redirect_to login_path, notice: "Please Log in first." }
					end
				end
			end
			
			def set_api_version
				@api_version = 'One'
			end
	end
end