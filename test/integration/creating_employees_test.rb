require 'test_helper'

class CreatingEmployeesTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }

	test 'creates employees' do
		post '/employees', 
			{ employee: { id: '45543', name: 'Jason', division: 'ASF', authentication: '7878342901', address: '#333 Side Coast' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 201, response.status
		assert_equal Mime::JSON, response.content_type

		employee = json(response.body)
		assert_equal api_employee_url(employee[:id]), response.location
	end

	test 'prevents creation if id is nil' do
		post '/employees', 
			{ employee: { id: nil, name: 'Jason', division: 'ASF', authentication: '7878342901', address: '#333 Side Coast' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
		assert_equal Mime::JSON, response.content_type
	end

	test 'prevents creation if name is nil' do
		post '/employees', 
			{ employee: { id: '45543', name: nil, division: 'ASF', authentication: '7878342901', address: '#333 Side Coast' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
		assert_equal Mime::JSON, response.content_type
	end

	test 'prevents creation if division is nil' do
		post '/employees', 
			{ employee: { id: '45543', name: 'Jason', division: nil, authentication: '7878342901', address: '#333 Side Coast' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
		assert_equal Mime::JSON, response.content_type
	end

	test 'prevents creation if authentication is nil' do
		post '/employees', 
			{ employee: { id: '45543', name: 'Jason', division: 'ASF', authentication: nil, address: '#333 Side Coast' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
		assert_equal Mime::JSON, response.content_type
	end

	test 'prevents creation if authentication is too short' do
		post '/employees', 
			{ employee: { id: '45543', name: 'Jason', division: 'ASF', authentication: '67', address: '#333 Side Coast' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
		assert_equal Mime::JSON, response.content_type
	end

	test 'prevents creation if id is is taken' do
		post '/employees', 
			{ employee: { id: '12345', name: 'Jason', division: 'ASF', authentication: '67', address: '#333 Side Coast' } }.to_json, 
			{ 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

		assert_equal 422, response.status
		assert_equal Mime::JSON, response.content_type
	end
end