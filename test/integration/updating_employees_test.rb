require 'test_helper'

class UpdatingEmployeesTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }
	setup { @employee = Employee.create!( id: '55555', name: 'Mike', division: 'SSD', authentication: '67554893') }

	test 'updating employees' do
		patch "/employees/#{@employee.id}", 
			{ employee: { division: 'ERD' } }.to_json,
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 200, response.status
		assert_equal 'ERD', @employee.reload.division
	end

	test 'prevent update if authentication is too short' do
		patch "/employees/#{@employee.id}",
			{ employee: { authentication: '553' } }.to_json,
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
	end
end