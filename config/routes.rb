Rails.application.routes.draw do
  namespace :api do
  namespace :v1 do
    get 'discussions/create'
    end
  end

  namespace :api do
  namespace :v1 do
    get 'assignments/create'
    end
  end

  namespace :api do
    # All routes for API Version 1
    scope module: :v1, constraints: ApiConstraint.new(version: 1) do
      resources :users do
        get 'email', on: :collection
      end
      
      # resources :tokens, only: %w(create destroy)
      # resources :companies
      # resources :subscriptions, only: %w(create)
      # resources :customers, only: %w(create)
      # resources :password_resets, only: %w(create)
      # resources :projects, only: %w(create update show)
      # resources :companies_users, only: %w(create)
      # resources :projects_users, only: %w(create)      
      # resources :project_invitations, only: %w(create)
      # resources :company_invitations, only: %w(create)
      # resources :tasks, only: %w(create update)
      # resources :assignments, only: %w(create)
      # resources :discussions, only: %w(create)
      # resources :comments, only: %w(create)

      # get '/passwords' => 'user_passwords#new'
      # post '/passwords' => 'user_passwords#create'
      # put '/passwords' => 'user_passwords#update'
      # patch '/passwords' => 'user_passwords#update'
    end
    
    # Catch all API requests
    # These are the routes are used if no API constraint is sent
    scope module: :v1 do
      resources :users do
        get 'email', on: :collection
      end
      
      # resources :tokens, only: %w(create destroy)
      # resources :companies
      # resources :subscriptions, only: %w(create)
      # resources :customers, only: %w(create)
      # resources :password_resets, only: %w(create)
      # resources :projects, only: %w(create update show)
      # resources :companies_users, only: %w(create)
      # resources :projects_users, only: %w(create)
      # resources :project_invitations, only: %w(create)
      # resources :company_invitations, only: %w(create)
      # resources :tasks, only: %w(create update)
      # resources :assignments, only: %w(create)
      # resources :discussions, only: %w(create)
      # resources :comments, only: %w(create)
      # 
      # get '/passwords' => 'user_passwords#new'
      # post '/passwords' => 'user_passwords#create'
      # put '/passwords' => 'user_passwords#update'
      # patch '/passwords' => 'user_passwords#update'
    end
  end
end
