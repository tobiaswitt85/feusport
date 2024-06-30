# frozen_string_literal: true

Exports::Xlsx::Teams = Struct.new(:teams) do
  include Exports::Xlsx::Base
  include Exports::Teams

  def perform
    workbook.add_worksheet(name: Team.model_name.human(count: 0).truncate_bytes(30)) do |sheet|
      index_export_data(teams, full: true).each { |row| sheet.add_row row }
    end
  end

  def filename
    'mannschaften.xlsx'
  end
end
