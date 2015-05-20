require 'test_helper'

module API::V1
	class DeletingEmployeesTest < ActionDispatch::IntegrationTest
		test 'delete existing employee' do
			delete "/employees/#{@employee.id}", {}, { 'Authorization' => token_header(@user.auth_token), 'Accept' => Mime::JSON }
			assert_equal 204, response.status
		end
	end
end