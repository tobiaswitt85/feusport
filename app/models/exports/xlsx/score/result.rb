# frozen_string_literal: true

Exports::Xlsx::Score::Result = Struct.new(:result) do
  include Exports::Xlsx::Base
  include Exports::ScoreResults

  def perform
    single_table
    group_table if result.group_assessment? && discipline.single_discipline?
  end

  protected

  def bold
    @bold = workbook.styles.add_style(b: true)
  end

  def italic
    @italic = workbook.styles.add_style(i: true)
  end

  def single_table
    workbook.add_worksheet(name: result.name.truncate_bytes(30)) do |sheet|
      build_data_rows(result, discipline, false).each { |row| sheet.add_row(row) }
    end
  end

  def group_table
    workbook.add_worksheet(name: 'Mannschaftswertung') do |sheet|
      build_group_data_rows(result).each { |row| sheet.add_row(row) }

      sheet.add_row []
      sheet.add_row []
      build_group_data_details_rows(result).each do |team_result|
        sheet.add_row [team_result.team.full_name, team_result.result_entry.human_time], style: bold
        team_result.rows_in.each { |row| sheet.add_row(row) }
        team_result.rows_out.each { |row| sheet.add_row(row, style: italic) }

        sheet.add_row []
        sheet.add_row []
      end
    end
  end
end
