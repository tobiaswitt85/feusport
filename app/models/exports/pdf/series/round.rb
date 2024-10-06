# frozen_string_literal: true

Exports::Pdf::Series::Round = Struct.new(:round, :competition) do
  include Exports::Pdf::Base

  def export_title
    round.name
  end

  def default_prawn_options
    super.merge(page_layout: :landscape)
  end

  def perform
    first = true
    Genderable::KEYS.each do |gender|
      pdf.start_new_page unless first
      first = false

      pdf_header("#{round.name} - #{t("gender.#{gender}")}", force_name: true)
      pdf.table(index_export_data(gender),
                header: true,
                row_colors: pdf_default_row_colors,
                width: pdf.bounds.width) do
        row(0).style(align: :center, font_style: :bold)
        column(0).style(align: :center)
        column(1).style(align: :center)
        column(-3).style(align: :center)
        column(-2).style(align: :center)
        column(-1).style(align: :center)
      end
    end
    pdf_footer(name: round.name, force_name: true)
  end

  protected

  def index_export_data(gender)
    headline = %w[Platz Team]
    round.showable_cups(competition).each do |cup|
      headline.push(cup.competition_place)
    end
    headline += ['Teil.', 'Bestzeit', 'Punkte']

    data = [headline]

    round.team_assessment_rows(competition, gender).each do |row|
      line = [row.rank, row.full_name]
      round.showable_cups(competition).each do |cup|
        participations = row.participations_for_cup(cup)
        if participations.present?
          d = participations.map do |participation|
            [participation.assessment.discipline.upcase, participation.result_entry_with_points]
          end
          my_table = pdf.make_table(d, cell_style: { size: 10, borders: [] })
          line.push(my_table)
        else
          line.push('')
        end
      end
      line += [row.count, row.best_result_entry, row.points]

      data.push(line)
    end
    data
  end
end
