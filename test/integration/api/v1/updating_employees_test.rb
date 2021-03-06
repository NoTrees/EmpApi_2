require 'test_helper'

module API::V1
	class UpdatingEmployeesTest < ActionDispatch::IntegrationTest
		test 'updating employees' do
			patch "/employees/#{@employee.id}", 
				{ employee: { division: 'ERD' } }.to_json,
				{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

			assert_equal 200, response.status
			assert_equal 'ERD', @employee.reload.division
		end
	end
end