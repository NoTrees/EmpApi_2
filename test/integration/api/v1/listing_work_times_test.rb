require 'test_helper'

module API::V1
	class ListingWorkTimesTest < ActionDispatch::IntegrationTest
		test 'return list of work times' do
			get '/work_times', {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status
			refute_empty response.body
		end

		test 'return list of work times in JSON' do
			get '/work_times', {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status
			assert_equal Mime::JSON, response.content_type
		end

		test 'return list of work times in XML' do
			get '/work_times', {}, { 'Accept' => Mime::XML }
			assert_equal 200, response.status
			assert_equal Mime::XML, response.content_type
		end

		test 'return work times filtered by id' do
			get '/work_times?employee_id=12345', {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status

			work_times = json(response.body)
			ids = work_times.collect { |z| z[:employee_id] }
			assert_includes ids, 12345
			refute_includes ids, 67890
		end

		test 'return work times filtered by work date' do
			get '/work_times?work_date=2015-05-14', {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status

			work_times = json(response.body)
			ids = work_times.collect { |z| z[:employee_id] }
			assert_includes ids, 12345
			refute_includes ids, 67890
		end
	end
end