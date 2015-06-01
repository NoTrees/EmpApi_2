module API::V1
	class VersionController < ApplicationController
		abstract!

		before_action :set_api_version

		protected
			def logged_in_employee
				unless logged_in?
					respond_to do |format|
						format.html { redirect_to login_path, notice: "Please Log in first." }
						format.json { render json: "Cannot do that! Please login first" , status: :unauthorized }
						format.xml { render xml: { error: 'Cannot do that! Please login first' } , status: :unauthorized }
					end
				end
			end

		private
			def set_api_version
				@api_version = 'One'
			end
	end
end