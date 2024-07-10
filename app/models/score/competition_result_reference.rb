# frozen_string_literal: true

class Score::CompetitionResultReference < ApplicationRecord
  belongs_to :result, class_name: 'Score::Result', touch: true
  belongs_to :competition_result, class_name: 'Score::CompetitionResult'

  schema_validations
end
