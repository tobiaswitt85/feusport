# frozen_string_literal: true

FactoryBot.define do
  factory :user_access_request do
    competition
    sender { User.first || association(:user) }
    email { 'access@request.de' }
    text {  "Hallo\nwillst du?" }
  end
end
