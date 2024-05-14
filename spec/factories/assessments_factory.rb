# frozen_string_literal: true

FactoryBot.define do
  factory :assessment do
    band { association :band, competition: }
    discipline
  end
end
