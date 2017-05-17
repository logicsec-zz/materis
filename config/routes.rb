Materis::Application.routes.draw do

  resources :oauth_applications

  use_doorkeeper
  resources :milestones

  get "reports/index"
  get "reports/activities"
  get "reports/employees_daily"
  get "reports/employee_day"
  get "reports/employees_time_range"
  get "reports/employee_range"
  get "reports/tasks"
  get "reports/task"
  get "reports/okrs"
  get "reports/get_selection_list"
  get "reports/employee_tasks"
  get "reports/worklogs"
  get "reports/day_log"
  get "reports/assignments"

  resources :work_logs do
    member do
      post 'delete_request'
      post 'ignore_request'
    end
  end

  get "calendar/index"
  get "calendar/monthly"
  get "calendar/day"
  get "calendar/week"
  resources :comments do
    member do
      get 'reply'
      post 'post_reply'
    end
  end

  resources :tasks do
    resources :comments
    member do
      post 'completion'
    end
    collection do
      get 'completed_index'
    end
  end

  resources :teams do
    get 'add_members'
    post 'add_members'
    collection do
      get 'get_member_list'
    end
  end

  get "home/index"
  get "home/dashboard"
  get "home/search"
  post "home/search"
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

  resources :projects, :path => 'departments' do
    get 'add_members'
    post 'add_members'
    collection do
      get 'get_member_list'
    end
    resources :teams
  end

  resources :jobs, :path => 'projects' do
    resources :comments
  end

  resources :users do
    resources :okrs do
      member do
        post 'approve'
      end
    end
    collection do
      get 'change_password'
      post 'change_password'
    end
  end

  namespace :api do
    namespace :v1 do
      get '/me' => "credentials#me"
    end
  end

  root 'home#index'
end
