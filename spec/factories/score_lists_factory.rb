# frozen_string_literal: true

FactoryBot.define do
  factory :score_list, class: 'Score::List' do
    competition
    assessments { [Assessment.find_by(competition:) || create(:assessment, competition:)] }
    results { [Score::Result.find_by(competition:) || create(:score_result, competition:)] }
    name { 'Hakenleitersteigen - Männer - Lauf 1' }
    shortcut { 'Lauf 1' }
  end

  factory :score_list_entry, class: 'Score::ListEntry' do
    list factory: %i[score_list]
    assessment { Assessment.find_by(competition:) || create(:assessment, competition:) }
    track { 1 }
    run { 1 }
    entity { Person.find_by(competition:) || build(:person, :with_team, competition:) }

    trait :result_valid do
      result_type { 'valid' }
    end
    trait :result_invalid do
      result_type { 'invalid' }
    end
  end
end
