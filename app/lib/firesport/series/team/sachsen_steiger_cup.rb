# frozen_string_literal: true

class Firesport::Series::Team::SachsenSteigerCup < Firesport::Series::Team::Base
  def self.max_points(*)
    10
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
      sum = @cups.values.flatten.sum(&:time)
      [sum, Firesport::INVALID_TIME].min
    end
  end

  def best_time
    @best_time ||= @cups.values.flatten.reject(&:time_invalid?).map(&:time).min || Firesport::INVALID_TIME
  end
end
