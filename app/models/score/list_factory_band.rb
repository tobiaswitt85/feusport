# frozen_string_literal: true

class Score::ListFactoryBand < ApplicationRecord
  belongs_to :band
  belongs_to :list_factory, class_name: 'Score::ListFactory'

  schema_validations
end
