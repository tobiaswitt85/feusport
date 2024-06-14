# frozen_string_literal: true

class UserAccess < ApplicationRecord
  belongs_to :user
  belongs_to :competition

  schema_validations
end
