# frozen_string_literal: true

FactoryBot.define do
  factory :score_competition_result, class: 'Score::CompetitionResult' do
    competition
    name { 'Wettkampf' }
    result_type { 'dcup' }
  end
end
