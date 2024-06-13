# frozen_string_literal: true

class Firesport::Series::Team::LaCup < Firesport::Series::Team::Base
  def self.assessment_disciplines
    { la: [''] }
  end

  def points
    @points ||= ordered_participations.map(&:points).sum
  end

  def <=>(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    best_time_without_nil <=> other.best_time_without_nil
  end

  protected

  def ordered_participations
    @ordered_participations ||= @cups.values.map(&:first).sort do |a, b|
      compare = b.points <=> a.points
      compare.zero? ? a.time <=> b.time : compare
    end.first(calc_participation_count)
  end

  def calc_participation_count
    3
  end

  def best_rank
    @cups.values.flatten.map(&:rank).min
  end

  def best_rank_count
    @cups.values.flatten.map(&:rank).count { |r| r == best_rank }
  end
end
