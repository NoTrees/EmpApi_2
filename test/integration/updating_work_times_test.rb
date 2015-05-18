require 'test_helper'

class UpdatingWorkTimesTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }
	setup { @work_time = WorkTime.create!( employee_id: '12345', time_of_scan: '08:00:00', time_flag: 'logged_out', work_date: '2015-05-18' ) }

	test 'updating work times' do
		patch "/work_times/#{@work_time.id}", 
			{ work_time: { time_flag: 'logged_in' } }.to_json,
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 200, response.status
		assert_equal 'logged_in', @work_time.reload.time_flag
	end
end