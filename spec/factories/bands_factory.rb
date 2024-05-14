# frozen_string_literal: true

FactoryBot.define do
  factory :band do
    gender { 'female' }
    name { 'Frauen' }

    trait :female do
    end

    trait :male do
      gender { 'male' }
      name { 'Männer' }
    end

    trait :youth do
      gender { 'indifferent' }
      name { 'Jugend' }
    end
  end
end
