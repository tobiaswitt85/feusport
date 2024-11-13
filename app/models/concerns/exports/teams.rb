# frozen_string_literal: true

module Exports::Teams
  protected

  def index_export_data(band, full: false, all_columns: false)
    collection = band.teams.sort

    headline = [
      Team.human_attribute_name(:name),
      'Wettkä.',
    ]
    headline.push('Los') if competition.lottery_numbers?
    headline.push(Team.human_attribute_name(:shortcut)) if full
    band.team_tags.each { |tag| headline.push(tag) }

    assessments = Assessment.requestable_for_team(band)
    assessments.each do |assessment|
      full_name = assessment.name
      full_name = full_name.gsub(band.name, '').strip
      full_name = full_name.gsub(/\s*-\s*-\s*/, ' - ').strip
      full_name = full_name.gsub(/-\Z/, '').strip
      full_name = full_name.gsub(/\s*-\s*-\s*/, ' - ').strip
      full_name = full_name.gsub(/-\Z/, '').strip
      headline.push(full_name)
    end

    if all_columns
      team_markers.each do |team_marker|
        headline.push(full ? team_marker.name : team_marker.name.truncate(10))
      end
    end

    data = [headline]

    collection.each do |team|
      pc = team.people.count
      line = [
        team.full_name,
        pc.zero? ? '-' : pc,
      ]
      line.push(team.lottery_number) if competition.lottery_numbers?
      line.push(team.shortcut) if full
      band.team_tags.each { |tag| line.push(team.tags.include?(tag) ? 'X' : '') }

      assessments.each do |assessment|
        if team.request_for(assessment).blank?
          line.push('')
        else

          # TODO: if assessment.like_fire_relay?
          # TODO  #{team.request_for(assessment).relay_count} x
          line.push(t("assessment_types.#{team.request_for(assessment).assessment_type}_short"))
        end
      end

      if all_columns
        team_markers.each do |team_marker|
          value = team.team_marker_values.find_by(team_marker:)
          line.push(full ? value&.value : value&.value.to_s.gsub(/\s/, ' ').truncate(10))
        end
      end

      data.push(line)
    end
    data
  end

  def team_markers
    @team_markers ||= competition.team_markers.reorder(:name)
  end

  def export_title
    'Mannschaften'
  end
end
