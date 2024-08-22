# frozen_string_literal: true

Exports::Xlsx::Bands = Struct.new(:competition) do
  include Exports::Xlsx::Base
  include Exports::Bands

  def perform
    add_worksheet(export_title) do |sheet|
      index_export_data(competition.bands.sort).each { |row| sheet.add_row(row) }
    end
  end
end
