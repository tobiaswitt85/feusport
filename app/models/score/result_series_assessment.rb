# frozen_string_literal: true

class Score::ResultSeriesAssessment < ApplicationRecord
  belongs_to :assessment, class_name: 'Series::Assessment', inverse_of: :assessment_score_results
  belongs_to :result, class_name: 'Score::Result', inverse_of: :result_series_assessments

  def self.exists_for?(competition)
    competition.score_results.joins(:result_series_assessments).exists?
  end

  schema_validations
end
