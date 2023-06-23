# frozen_string_literal: true

class Competition < ApplicationRecord
  schema_validations

  scope :visible, -> { where(visible: true) }
  scope :current, -> { visible.where(date: (5.days.ago..5.days.from_now)) }
  scope :upcoming, -> { visible.where(date: (Date.tomorrow..)) }
  scope :previous, -> { visible.where(date: (..Date.yesterday)) }
end
