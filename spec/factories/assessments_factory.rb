# frozen_string_literal: true

FactoryBot.define do
  factory :assessment do
    competition
    band { association :band, competition: }
    discipline { association :discipline, :hl, competition: }
  end

  factory :assessment_request do
    entity do
      association(:team, competition: assessment.competition, band: assessment.band,
                         disable_autocreate_assessment_requests: true)
    end
    assessment_type { :group_competitor }
  end
end
