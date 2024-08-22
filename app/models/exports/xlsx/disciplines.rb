# frozen_string_literal: true

Exports::Xlsx::Disciplines = Struct.new(:competition) do
  include Exports::Xlsx::Base
  include Exports::Disciplines

  def perform
    add_worksheet(export_title) do |sheet|
      index_export_data(competition.disciplines.sort).each { |row| sheet.add_row(row) }
    end
  end
end
