# frozen_string_literal: true

class UserAccess < ApplicationRecord
  belongs_to :user
  belongs_to :competition, touch: true

  schema_validations
end
