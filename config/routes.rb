Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  devise_for :users,
              controllers: {
                sessions: 'users/sessions',
                registrations: 'users/registrations'
              }

  namespace :api do
    resources :images, only: [:create, :index]
    resources :users, only: :index
  end

  namespace :webhooks do
    resources :cartoons, only: :index
    resources :sketches, only: :index
  end
end
