require 'test_helper'

module API::V1
	class ListingEmployeesTest < ActionDispatch::IntegrationTest
		test 'valid authentication with token' do
			get '/employees', {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status
			assert_equal Mime::JSON, response.content_type
		end

		test 'invalid authentication' do
			get '/employees', {}, { 'Authorization' => @auth_header + 'fake', 'Accept' => Mime::JSON }
			assert_equal 401, response.status
		end

		test 'return list of employees' do
			get '/employees', {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status
			refute_empty response.body
		end

		test 'return list of employees in JSON' do
			get '/employees', {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status
			assert_equal Mime::JSON, response.content_type
		end

		test 'return list of employees in XML' do
			get '/employees', {}, { 'Accept' => Mime::XML }
			assert_equal 200, response.status
			assert_equal Mime::XML, response.content_type
		end

		test 'return employee by id' do
			employee = Employee.create!( id: '45453', name: 'Jacob', division: 'ATT', authentication: '8765094321' )

			get "/employees/#{employee.id}", {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status

			employee_response = json(response.body)
			assert_equal employee.name, employee_response[:name]
		end

		test 'return employees filtered by division' do
			get '/employees?division=ERD', {}, { 'Accept' => Mime::JSON }
			assert_equal 200, response.status

			divisions = json(response.body)
			names = divisions.collect { |z| z[:name] }
			assert_includes names, 'Emily'
			refute_includes names, 'Rose'
		end
	end
end