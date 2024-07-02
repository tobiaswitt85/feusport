# frozen_string_literal: true

class Firesport::Series::Person::SachsenSteigerCup < Firesport::Series::Person::MvCup
  def self.max_points(*)
    30
  end

  def <=>(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    compare = sum_time <=> other.sum_time
    return compare unless compare.zero?

    best_time <=> other.best_time
  end
end
