Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    resources :images, only: [:create, :index]
  end
  namespace :webhooks do
    resources :cartoons, only: :index
    resources :sketches, only: :index
  end 
end
