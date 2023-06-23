# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :competitions, only: %i[index show]
end
