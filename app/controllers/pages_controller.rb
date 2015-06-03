class PagesController < ApplicationController
  before_action :logged_in_employee

  # ROUTE: pages#home
  # PATH:  home
  #
  # home page for employees
  def home
  end

  private
  	  # prevents access to this page if there is no one logged in
	  def logged_in_employee
	  	# logged_in? method present in the Sessions Helper located in app/helpers and is included in the application controller
	  	unless logged_in?
		  respond_to do |format|
		  	# HTML redirects users to the log in page if they try to access other pages
		  	format.html { redirect_to login_path, notice: "Please Log in first." }
		  	# JSON renders the error message given and gives an unauthorized response
		  	format.json { render json: "Cannot do that! Please login first" , status: :unauthorized }
		  	# XML renders the error message given and gives an unauthorized response
			format.xml { render xml: { error: 'Cannot do that! Please login first' } , status: :unauthorized }
		  end
	  	end
	  end
end
