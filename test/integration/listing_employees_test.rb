require 'test_helper'

class ListingEmployeesTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }

	test 'return list of employees' do
		get '/employees'
		assert_equal 200, response.status
		refute_empty response.body
	end

	test 'return employee by id' do
		employee = Employee.create!( id: '45453', name: 'Jacob', division: 'ATT', authentication: '8765094321' )

		get "/employees/#{employee.id}"
		assert_equal 200, response.status

		employee_response = json(response.body)
		assert_equal employee.name, employee_response[:name]
	end

	test 'return employees filtered by division' do
		get '/employees?division=ERD'
		assert_equal 200, response.status

		divisions = json(response.body)
		names = divisions.collect { |z| z[:name] }
		assert_includes names, 'Emily'
		refute_includes names, 'Rose'
	end
end