require 'test_helper'

class DeletingEmployeesTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }
	setup { @employee = Employee.create( id: '84438', name: 'James', division: 'SSF', authentication: '1344455' ) }

	test 'delete existing employee' do
		delete "/employees/#{@employee.id}"
		assert_equal 204, response.status
	end
end