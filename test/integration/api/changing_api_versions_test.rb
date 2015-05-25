require 'test_helper'

module API
	class ChangingApiVersionTest < ActionDispatch::IntegrationTest
		test 'return employee list in version one via Accept header' do
			get '/employees.json', {},
				{ 'REMOTE_ADDR' => @ip, 'Accept' => 'application/vnd.empapp.v1+json' }

			employee = Employee.all.to_json
			assert_equal 200, response.status
			assert_equal employee, response.body
			assert_equal Mime::JSON, response.content_type
		end

		test 'return work time list in version one via Accept header' do
			get '/work_times.json', {},
				{ 'REMOTE_ADDR' => @ip, 'Accept' => 'application/vnd.empapp.v1+json' }

			work_time = WorkTime.all.to_json
			assert_equal 200, response.status
			assert_equal work_time, response.body
			assert_equal Mime::JSON, response.content_type
		end
	end
end