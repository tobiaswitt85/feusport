# frozen_string_literal: true

class Firesport::Series::Team::DCup < Firesport::Series::Team::Base
  def self.max_points(_round, gender:)
    10
  end

  def self.assessment_disciplines
    { la: [''], fs: [''], gs: [''] }
  end

  def self.group_assessment_disciplines
    { hl: [''], hb: [''], hw: [''] }
  end

  def self.points_for_rank(row, ranks)
    points = super
    row.competition_result_valid? ? points : 0
  end

  def <=>(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    best_time_without_nil <=> other.best_time_without_nil
  end
end
