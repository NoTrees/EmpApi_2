require 'test_helper'

module API:V1
	class DeletingWorkTimesTest < ActionDispatch::IntegrationTest
		test 'delete existing work time' do
			delete "/work_times/#{@work_time.id}", {}, { 'Accept' => Mime::JSON }
			assert_equal 204, response.status
		end
	end
end