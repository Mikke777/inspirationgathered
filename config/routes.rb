Rails.application.routes.draw do
  devise_for :users
  root to: "workshops#index"
  resources :users, only: [:show]
  resources :workshops do
    resources :bookings, only: [:create, :destroy] do
      member do
        get :chat
        post :accept
        post :reject
      end
      resources :messages, only: [:create]
    end
    collection do
      get :booked
      get :dashboard
      get :inbox
    end
  end

  resources :notifications, only: [] do
    member do
      post :mark_as_read
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
