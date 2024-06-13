# frozen_string_literal: true

class Firesport::Series::Team::VierBahnenPokal2019 < Firesport::Series::Team::LaCup
  def self.max_points(_round, gender:)
    15
  end

  def self.points_for_result(rank, time, round, double_rank_count: 0, gender:)
    if rank == 1
      25
    elsif rank == 2
      20
    elsif rank == 3
      16
    elsif rank == 4
      13
    else
      super(rank, time, round, double_rank_count: double_rank_count, gender: gender)
    end
  end

  def self.special_sort!(rows)
    honor_rows = rows.select { |row| row.rank.present? && row.rank <= 3 }.sort { |row, other| row.honor_sort(other) }
    honor_rows.each { |row| row.calculate_rank!(honor_rows) }
    rows.sort_by! { |row| row.rank || 999 }
  end

  def <=>(other)
    other.points <=> points
  end

  def honor_sort(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    compare = best_rank <=> other.best_rank
    return compare unless compare.zero?

    compare = other.best_rank_count <=> best_rank_count
    return compare unless compare.zero?

    sum_time <=> other.sum_time
  end

  protected

  def calc_participation_count
    4
  end

  def sum_time
    @sum_time ||= begin
      sum = ordered_participations.map(&:time).sum
      if sum >= Firesport::INVALID_TIME
        Firesport::INVALID_TIME
      else
        sum
      end
    end
  end
end
