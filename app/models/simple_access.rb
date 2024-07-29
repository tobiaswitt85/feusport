# frozen_string_literal: true

class SimpleAccess < ApplicationRecord
  include SortableByName

  belongs_to :competition
  has_secure_password

  schema_validations
end
