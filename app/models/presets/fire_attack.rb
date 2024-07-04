# frozen_string_literal: true

class Presets::FireAttack < Presets::Base
  attr_accessor :selected_assessments
  attr_reader :selected_bands

  validates :selected_bands, :selected_assessments, presence: true

  def name
    'Löschangriff Nass (LA)'
  end

  def params
    [
      Param.new(:selected_bands, as: :check_boxes, collection: [%w[Frauen female], %w[Männer male], %w[Jugend youth]]),
      Param.new(:selected_assessments, as: :radio_buttons,
                                       collection: [['Eine Wertung: DIN oder TGL', 'single'],
                                                    ['Mehrere Wertungen: DIN und TGL', 'din_tgl'],
                                                    ['Mehrere Wertungen: Sport und Einsatz', 'sport_einsatz']]),
    ]
  end

  def selected_bands=(array)
    @selected_bands = array.compact_blank
  end

  protected

  def perform
    la = competition.disciplines.find_or_create_by(key: :la, name: Discipline::DEFAULT_NAMES[:la], short_name: 'LA',
                                                   single_discipline: false)

    if 'youth'.in?(selected_bands)
      youth = competition.bands.find_or_create_by!(gender: :indifferent, name: 'Jugend')
      youth_assessment = competition.assessments.find_or_create_by!(discipline: la, band: youth)
      competition.score_results.find_or_create_by!(assessment: youth_assessment)
    end

    { 'female' => 'Frauen', 'male' => 'Männer' }.each do |gender, name|
      next unless gender.in?(selected_bands)

      band = competition.bands.find_or_create_by!(gender:, name:)
      if selected_assessments.in?(%w[din_tgl sport_einsatz])
        groups = []
        groups = %w[DIN TGL] if selected_assessments == 'din_tgl'
        groups = %w[Sport Einsatz] if selected_assessments == 'sport_einsatz'

        groups.each do |group|
          assessment = competition.assessments.find_or_create_by!(discipline: la, band:,
                                                                  forced_name: "Löschangriff Nass - #{group} - #{name}")

          competition.score_results.find_or_create_by!(assessment:)
        end
      else
        assessment = competition.assessments.find_or_create_by!(discipline: la, band:)
        competition.score_results.find_or_create_by!(assessment:)
      end
    end
  end
end
