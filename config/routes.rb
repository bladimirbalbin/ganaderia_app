Rails.application.routes.draw do
  # Dashboard & Home
  root to: "dashboard#index"
  get 'dashboard', to: 'dashboard#index', as: :dashboard
  get 'settings', to: 'settings#index', as: :settings
  get 'home/index'
  get "up" => "rails/health#show", as: :rails_health_check
  get '/.well-known/*all', to: proc { [204, {}, ['']] }

  # Devise (usuarios)
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # Usuarios
  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    member do
      get :edit_password
      patch :change_password
    end
  end

  # Roles
  resources :roles

  # Empresas
  resources :companies do
    member do
      get :select_plan
      post :activate_plan
    end
  end

  # Registro de empresa (solo new y create)
  resources :company_registrations, only: [:new, :create]

  # Planes de membresía
  resources :membership_plans

  # Customers
  resources :customers, only: [:index, :show, :new, :edit, :create, :update, :destroy]
end
