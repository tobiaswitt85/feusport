# frozen_string_literal: true

class Score::ResultSeriesAssessment < ApplicationRecord
  belongs_to :assessment, class_name: 'Series::Assessment', inverse_of: :assessment_score_results
  belongs_to :result, class_name: 'Score::Result', inverse_of: :result_series_assessments

  schema_validations
end
