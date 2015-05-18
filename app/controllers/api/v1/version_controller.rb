module API::V1
	class VersionController < ApplicationController
		abstract!

		before_action :set_api_version
		before_action :authenticate

		def set_api_version
			@api_version = 'One'
		end

		protected
	      def authenticate
	        authenticate_token || render_unauthorized
	      end

	      def authenticate_token
	        authenticate_with_http_token do |token, options|
	          User.find_by(auth_token: token)
	        end
	      end

	      def render_unauthorized
	        self.headers['WWW-Authenticate'] = 'Token realm="Employee and Time Tables"'

	        respond_to do |format|
	          format.json { render json: 'Bad credentials', status: :unauthorized }
	          format.xml { render xml: 'Bad credentials', status: :unauthorized }
	        end
	      end
	end
end