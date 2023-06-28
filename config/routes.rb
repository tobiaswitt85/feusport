# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  namespace :competitions do
    resource :creations, only: %i[new create]
  end
  resources :competitions, only: %i[index]
  resources :competitions, path: '/:year', constraints: { year: /(\d{4})/ }, only: %i[show edit update destroy],
                           as: :competition
end
