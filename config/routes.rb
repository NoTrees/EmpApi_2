require 'api_version'

Rails.application.routes.draw do
  root 'api/v1/work_times#new'
  get 'home' => 'pages#home'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  namespace :api, path: '/' do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      resources :work_times
      resources :employees
    end
  end
end
