require 'api_version'

Rails.application.routes.draw do
  namespace :api, path: '/', constraints: { subdomain: 'api' } do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :work_times
      resources :employees
    end
  end
end
