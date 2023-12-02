Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    resources :images, only: [:create]
  end
end
