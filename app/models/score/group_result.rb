# frozen_string_literal: true

Score::GroupResult = Struct.new(:result) do
  include Score::Resultable

  delegate :assessment, to: :result

  def rows
    @rows ||= calculated_rows.sort
  end

  def calculated_rows
    team_scores = {}
    run_count = result.group_run_count
    score_count = result.group_score_count

    result.rows.each do |result_row|
      next unless result_row.list_entries.first.group_competitor?
      next if result_row.entity.team.nil?

      if team_scores[result_row.entity.team].nil?
        team_scores[result_row.entity.team] =
          Score::GroupResultRow.new(result_row.entity.team, score_count, run_count, self)
      end
      team_scores[result_row.entity.team].add_result_row(result_row)
    end
    team_scores.values.sort
  end
end
