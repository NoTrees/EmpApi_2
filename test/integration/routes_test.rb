require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
	test 'employee defaults to v1' do
		assert_generates '/employees', { controller: 'api/v1/employees', action: 'index' }
	end

	test 'work time defaults to v1' do
		assert_generates '/work_times', { controller: 'api/v1/work_times', action: 'index' }
	end
end