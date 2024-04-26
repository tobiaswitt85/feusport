# frozen_string_literal: true

class Score::ResultListFactory < ApplicationRecord
  belongs_to :list_factory, class_name: 'Score::ListFactory'
  belongs_to :result, class_name: 'Score::Result'

  schema_validations
end
