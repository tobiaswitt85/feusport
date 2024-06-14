# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Alfred Meier' }
    email { 'alfred@meier.de' }
    password { 'Password' }
    password_confirmation { 'Password' }
    confirmed_at { Date.current }

    trait :other do
      email { 'other@meier.de' }
      name { 'Other Meier' }
    end
  end
end
