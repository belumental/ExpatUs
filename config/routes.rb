Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users
  root to: "chats#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  get "list", to: "chats#list", as: :list

  resources :chats do
    resources :messages, only: [:new, :create]
  end

  resources :stareds, only: [:create, :destroy]
  get 'profile', to: 'users#show', as: :user

  get 'yourchats', to: 'chats#list_by_user', as: :yourchats

end
