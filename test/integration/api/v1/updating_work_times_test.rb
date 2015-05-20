require 'test_helper'

module API::V1
	class UpdatingWorkTimesTest < ActionDispatch::IntegrationTest
		test 'updating work times' do
			patch "/work_times/#{@work_time.id}", 
				{ work_time: { time_flag: 'logged_in' } }.to_json,
				{ 'Authorization' => token_header(@user.auth_token), 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

			assert_equal 200, response.status
			assert_equal 'logged_in', @work_time.reload.time_flag
		end
	end
end