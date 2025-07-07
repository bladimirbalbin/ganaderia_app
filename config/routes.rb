Rails.application.routes.draw do
  get 'customers/index'
  get 'customers/show'
  get 'customers/new'
  get 'customers/edit'
  get 'settings/index'
  get 'membership_plans/index'
  get 'membership_plans/show'
  get 'membership_plans/new'
  get 'membership_plans/edit'
  devise_for :users

  resources :users, only: [:show, :index, :new, :create, :edit, :update, :destroy]
  resources :roles

  resources :companies do
    member do
      get :select_plan
      post :activate_plan
    end
  end

  resources :membership_plans   # <== agrega esta línea

  get 'home/index'

  root to: "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get 'dashboard', to: 'dashboard#index', as: :dashboard
  get 'settings', to: 'settings#index', as: :settings
  get '/.well-known/*all', to: proc { [204, {}, ['']] }
  resources :customers

end
