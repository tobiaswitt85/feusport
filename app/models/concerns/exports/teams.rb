# frozen_string_literal: true

module Exports::Teams
  protected

  def index_export_data(band, full: false)
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
      data.push(line)
    end
    data
  end

  def export_title
    'Mannschaften'
  end
end
