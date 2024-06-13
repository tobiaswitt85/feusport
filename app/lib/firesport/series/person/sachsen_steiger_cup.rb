# frozen_string_literal: true

class Firesport::Series::Person::SachsenSteigerCup < Firesport::Series::Person::MVCup
  def self.max_points(_round, gender:)
    30
  end

  def self.assessment_disciplines
    { hl: ['', 'Nachwuchs'] }
  end

  def <=>(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    compare = sum_time <=> other.sum_time
    return compare unless compare.zero?

    best_time <=> other.best_time
  end
end
