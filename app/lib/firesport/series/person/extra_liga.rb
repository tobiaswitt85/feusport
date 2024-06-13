# frozen_string_literal: true

class Firesport::Series::Person::ExtraLiga < Firesport::Series::Person::Base
  def self.max_points(_round, gender:)
    0
  end

  def self.assessment_disciplines
    { hl: [''], hw: [''], hb: [''] }
  end

  def self.points_for_result(_rank, time, _round, _options = {})
    time == Firesport::INVALID_TIME ? 9999 : time
  end

  def sum_time
    @sum_time ||= ordered_participations.map(&:time).sum
  end

  def points
    @points ||= ordered_participations.map(&:points).sum + ((4 - max_count) * 9999)
  end

  def <=>(other)
    compare = other.max_count <=> max_count
    return compare unless compare.zero?

    compare = points <=> other.points
    return compare unless compare.zero?

    best_time <=> other.best_time
  end

  def max_count
    @max_count ||= [count, 4].min
  end

  protected

  def ordered_participations
    @ordered_participations ||= @participations.sort do |a, b|
      compare = a.points <=> b.points
      compare.zero? ? a.time <=> b.time : compare
    end.first(4)
  end
end
