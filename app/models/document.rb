# frozen_string_literal: true

class Document < ApplicationRecord
  belongs_to :competition, touch: true
  has_one_attached :file

  auto_strip_attributes :title

  schema_validations
  validates :file, presence: true,
                   blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'application/pdf'],
                           size_range: 1..(10.megabytes) }
end
