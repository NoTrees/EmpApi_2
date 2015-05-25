require 'api_version'

Rails.application.routes.draw do
  root 'pages#home'
  get 'new_work_time' => 'api/v1/work_times#new'
  get 'work_times' => 'api/v1/work_times#index'
  get 'new_employee' => 'api/v1/employees#new'
  get 'employees' => 'api/v1/employees#index'
  get 'delete_employee' => 'api/v1/employees#destroy'
  get 'POST' => 'api/v1/employees#create'


  namespace :api, path: '/' do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :work_times
      resources :employees
    end
  end
end
