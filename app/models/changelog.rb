# frozen_string_literal: true

class Changelog < ApplicationRecord
  schema_validations

  def html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(md)
  end
end
