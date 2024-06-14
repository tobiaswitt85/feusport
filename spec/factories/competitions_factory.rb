# frozen_string_literal: true

FactoryBot.define do
  factory :competition do
    users { [User.first || create(:user)] }
    name { 'MV-Cup' }
    date { Date.parse('2024-02-29') }
    locality { 'Rostock' }
    visible { true }
  end
end
