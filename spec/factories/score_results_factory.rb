# frozen_string_literal: true

FactoryBot.define do
  factory :score_result, class: 'Score::Result' do
    competition
    assessment
  end
end
