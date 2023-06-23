# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#home'
  resources :competitions, only: %i[index show]
end
