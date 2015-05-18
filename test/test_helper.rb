ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  setup { host! 'api.example.com' }
  setup { @ip = '123.123.12.12' }
  setup { @employee = Employee.create( id: '84438', name: 'James', division: 'SSF', authentication: '1344455' ) }
  setup { @work_time = WorkTime.create( employee_id: '12345', time_of_scan: '08:00:00', time_flag: 'logged_out', work_date: '2015-05-18' ) }
  setup { @user = User.create! }
  setup { @auth_header = "Token token=#{@user.auth_token}" }

  # Add more helper methods to be used by all tests here...
  def json(body)
  	JSON.parse(body, symbolize_names: true)
  end

  def token_header(token)
  	ActionController::HttpAuthentication::Token.encode_credentials(token)
  end
end
