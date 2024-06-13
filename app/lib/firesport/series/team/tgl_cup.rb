# frozen_string_literal: true

class Firesport::Series::Team::TglCup < Firesport::Series::Team::LaCup
  def self.max_points(round, gender:)
    if gender.to_sym == :male
      case round.year.to_i
      when 2024 then 11
      when 2019 then 16
      when 2018 then 16
      when 2017 then 10
      when 2016 then 13
      when 2015 then 15
      when 2014 then 10
      else 15
      end
    else
      1
    end
  end

  def calc_participation_count
    round.full_cup_count - 1
  end

  def <=>(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    compare = best_rank <=> other.best_rank
    return compare unless compare.zero?

    compare = other.best_rank_count <=> best_rank_count
    return compare unless compare.zero?

    other.ordered_participations.count <=> ordered_participations.count
  end
end
