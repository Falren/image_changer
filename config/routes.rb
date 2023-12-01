Rails.application.routes.draw do
  namespace :api do
    resources :images, only: [:create]
  end
end
