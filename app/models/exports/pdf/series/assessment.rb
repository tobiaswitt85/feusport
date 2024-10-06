# frozen_string_literal: true

Exports::Pdf::Series::Assessment = Struct.new(:assessment, :competition) do
  include Exports::Pdf::Base

  def export_title
    assessment.name
  end

  def default_prawn_options
    super.merge(page_layout: :landscape)
  end

  def perform
    pdf_header(assessment.name, force_name: true)
    pdf.table(index_export_data,
              header: true,
              row_colors: pdf_default_row_colors,
              width: pdf.bounds.width,
              cell_style: { align: :center, size: 9 }) do
      row(0).style(align: :center, font_style: :bold)
      column(0).style(size: 10)
      column(1).style(size: 10)
      column(2).style(size: 10)
      column(-4).style(size: 10)
      column(-3).style(size: 10)
      column(-2).style(size: 10)
      column(-1).style(size: 10)
    end
    pdf_footer(name: assessment.to_label, force_name: true)
  end

  protected

  def index_export_data
    headline = %w[Platz Name Vorname]
    assessment.round.showable_cups(competition).each do |cup|
      headline.push(cup.competition_place)
    end
    headline += ['Bestzeit', 'Summe', 'Teil.', 'Punkte']

    data = [headline]

    assessment.rows(competition).each do |row|
      line = [row.rank, row.entity.last_name, row.entity.first_name]
      assessment.round.showable_cups(competition).each do |cup|
        line.push(row.participation_for_cup(cup)&.result_entry_with_points&.to_s)
      end
      line += [row.best_result_entry, row.sum_result_entry, row.count, row.points]

      data.push(line)
    end
    data
  end
end
