require 'test_helper'

class CreatingWorkTimesTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }

	test 'creates work times' do
		post '/work_times', 
			{ 
				work_time: { 
					employee_id: '12345', 
					time_of_scan: '08:00:00', 
					time_flag: 'logged_in', 
					work_date: '2015-05-14' 
				} 
			}.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 201, response.status
		assert_equal Mime::JSON, response.content_type

		work_time = json(response.body)
		assert_equal api_v1_work_time_url(work_time[:id]), response.location
	end

	test 'prevents creation if employee_id is nil' do
		post '/work_times', 
			{ work_time: { employee_id: nil, time_of_scan: '08:00:00', time_flag: 'logged_in', work_date: '2015-05-14' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
		assert_equal Mime::JSON, response.content_type
	end

	test 'prevents creation if employee does not exist' do
		post '/work_times', 
			{ work_time: { employee_id: '45543', time_of_scan: '08:00:00', time_flag: 'logged_in', work_date: '2015-05-14' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
		assert_equal Mime::JSON, response.content_type
	end
end