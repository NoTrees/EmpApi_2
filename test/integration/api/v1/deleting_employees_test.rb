require 'test_helper'

module API::V1
	class DeletingEmployeesTest < ActionDispatch::IntegrationTest
		test 'delete existing employee' do
			delete "/employees/#{@employee.id}", {}, { 'Accept' => Mime::JSON }
			assert_equal 204, response.status
		end
	end
end