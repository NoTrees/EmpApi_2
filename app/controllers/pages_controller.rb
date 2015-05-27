class PagesController < ApplicationController
  before_action :logged_in_employee

  def home
  end

  private
	  def logged_in_employee
	  	unless logged_in?
		  respond_to do |format|
		  	format.html { redirect_to login_path, notice: "Please Log in first." }
		  end
	  	end
	  end
end
