# frozen_string_literal: true

class Firesport::Series::Team::SachsenSteigerCup < Firesport::Series::Team::Base
  def self.max_points(_round, gender:)
    10
  end

  def self.group_assessment_disciplines
    { hl: [''] }
  end

  def <=>(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    compare = sum_time <=> other.sum_time
    return compare unless compare.zero?

    best_time <=> other.best_time
  end

  def sum_time
    @sum_time ||= begin
      sum = @cups.values.flatten.map(&:time).sum
      if sum >= Firesport::INVALID_TIME
        Firesport::INVALID_TIME
      else
        sum
      end
    end
  end

  def best_time
    @best_time ||= begin
      @cups.values.flatten.reject(&:time_invalid?).map(&:time).min || Firesport::INVALID_TIME
    end
  end
end
