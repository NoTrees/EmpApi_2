require 'api_version'

Rails.application.routes.draw do
  root 'pages#home'

  namespace :api, path: '/' do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :work_times
      resources :employees
    end
  end
end
