require 'test_helper'

class ListingWorkTimesTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }

	test 'return list of work times' do
		get '/work_times'
		assert_equal 200, response.status
		refute_empty response.body
	end

	test 'return work times filtered by id' do
		get '/work_times?employee_id=12345'
		assert_equal 200, response.status

		work_times = json(response.body)
		ids = work_times.collect { |z| z[:employee_id] }
		assert_includes ids, 12345
		refute_includes ids, 67890
	end

	test 'return work times filtered by work date' do
		get '/work_times?work_date=2015-05-14'
		assert_equal 200, response.status

		work_times = json(response.body)
		ids = work_times.collect { |z| z[:employee_id] }
		assert_includes ids, 12345
		refute_includes ids, 67890
	end

	test 'return work times filtered by work date and employee id' do
		get '/work_times?employee_id=12345&&work_date=2015-05-14'
		assert_equal 200, response.status

		work_times = json(response.body)
		ids = work_times.collect { |z| z[:employee_id] }
		dates = work_times.collect { |z| z[:work_date] }
		assert_includes ids, 12345
		assert_includes dates, "2015-05-14"
		refute_includes ids, 67890
		refute_includes dates, "2015-05-15"
	end
end