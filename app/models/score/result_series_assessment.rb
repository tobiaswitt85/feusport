# frozen_string_literal: true

class Score::ResultSeriesAssessment < ApplicationRecord
  belongs_to :series_assessment, class_name: 'Series::Assessment', inverse_of: :assessment_results
  belongs_to :score_result, class_name: 'Score::Result', inverse_of: :series_assessment_results
  schema_validations
end
