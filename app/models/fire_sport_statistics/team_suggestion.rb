# frozen_string_literal: true

FireSportStatistics::TeamSuggestion = Struct.new(:team) do
  delegate :count, :first, :present?, to: :suggestions

  def suggestions
    @suggestions ||= FireSportStatistics::Team.for_team(team)
  end
end
