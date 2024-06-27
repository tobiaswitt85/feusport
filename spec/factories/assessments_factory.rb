# frozen_string_literal: true

FactoryBot.define do
  factory :assessment do
    competition
    band { association :band, competition: }
    discipline { association :discipline, :hl, competition: }
  end
end
