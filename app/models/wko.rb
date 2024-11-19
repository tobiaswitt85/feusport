# frozen_string_literal: true

class Wko < ApplicationRecord
  has_one_attached :file

  auto_strip_attributes :slug, :name, :subtitle, :description_md

  schema_validations
  validates :file, presence: true, blob: { content_type: ['application/pdf'] }

  def self.current
    find_by(slug: '2023')
  end

  def description_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(description_md)
  end
end
