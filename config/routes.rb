Rails.application.routes.draw do
  devise_for :users,
              controllers: {
                sessions: 'users/sessions',
                registrations: 'users/registrations'
              }

  namespace :api do
    resources :images, only: [:create, :index]
  end

  namespace :webhooks do
    resources :cartoons, only: :index
    resources :sketches, only: :index
  end
end
