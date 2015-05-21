require 'api_version'

Rails.application.routes.draw do
  resources :users
  root 'users#index'

  namespace :api, path: '/' do#, constraints: { subdomain: 'api' } do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :work_times
      resources :employees
    end
  end
end
