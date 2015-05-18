require 'test_helper'

class DeletingWorkTimesTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }
	setup { @work_time = WorkTime.create( employee_id: '12345', time_of_scan: '08:00:00', time_flag: 'logged_out', work_date: '2015-05-18' ) }

	test 'delete existing work time' do
		delete "/work_times/#{@work_time.id}"
		assert_equal 204, response.status
	end
end