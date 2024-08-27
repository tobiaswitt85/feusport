# frozen_string_literal: true

class TeamImport
  include ActiveModel::Model

  attr_accessor :import_rows, :band_id, :competition

  validates :band_id, :import_rows, presence: true
  validates :band, same_competition: true

  def save
    return false unless valid?

    teams.all?(&:save!)
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:import_rows, e.message)
    false
  end

  def teams
    @teams ||= build_teams
  end

  def band
    @band = competition.bands.find_by(id: band_id)
  end

  protected

  def build_teams
    import_rows.to_s.lines.map(&:strip).compact_blank.map do |team_name|
      Team.new(competition:, name: team_name, shortcut: clean_and_cut_shortcut(team_name), band:)
    end.select(&:valid?)
  end

  def clean_and_cut_shortcut(long)
    loop do
      before = long
      long = long.gsub(/\AFF\s/, '')
      long = long.gsub(/\ABF\s/, '')
      long = long.gsub(/\AOB\s/, '')
      long = long.gsub(/\ATeam\s/, '')
      long = long.gsub(/\AWettkampfteam\s/i, '')
      long = long.gsub(/\AWettkampfgruppe\s/i, '')
      long = long.gsub(/Berufsfeuerwehr/i, '')
      long = long.gsub(/Gruppe/i, '')
      long = long.gsub(/Wettkampf/i, '')
      long = long.gsub(/Freiwillige/i, '')
      long = long.gsub(/Feuerwehr/i, '')
      long = long.gsub(/Ostseebad/i, '')
      long = long.gsub(/\s-\s/, '-')
      long = long.strip
      break if before == long
    end
    long.first(12)
  end
end
