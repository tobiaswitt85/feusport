# frozen_string_literal: true

class Competition < ApplicationRecord
  schema_validations

  belongs_to :user

  scope :visible, -> { where(visible: true) }
  scope :current, -> { visible.where(date: (5.days.ago..5.days.from_now)) }
  scope :upcoming, -> { visible.where(date: (Date.tomorrow..)) }
  scope :previous, -> { visible.where(date: (..Date.yesterday)) }

  before_validation(on: :create) do
    self.year = date&.year
    self.slug = name&.parameterize
    i = 0
    while Competition.exists?(year:, slug:)
      i += 1
      self.slug = "#{name.to_s.parameterize}-#{i}"
    end
  end

  def description_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(description)
  end
end
