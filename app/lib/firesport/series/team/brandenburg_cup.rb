# frozen_string_literal: true

class Firesport::Series::Team::BrandenburgCup < Firesport::Series::Team::LaCup
  def self.max_points(_round, gender:)
    16
  end

  def self.points_for_result(rank, time, round, double_rank_count: 0, gender:)
    if rank == 1
      max_points(round, gender: gender) - double_rank_count
    else
      super(rank + 1, time, round, double_rank_count: double_rank_count, gender: gender)
    end
  end

  def <=>(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    compare = other.participation_count <=> participation_count
    return compare unless compare.zero?

    sum_time <=> other.sum_time
  end

  def calculate_rank!(other_rows)
    current_rank = 0
    other_rows.each do |rank_row|
      if rank_row.participation_count < (round.year.to_i == 2022 ? 2 : 3)
        return @rank = nil if rank_row == self

        next
      end
      current_rank += 1
      return @rank = current_rank if (self <=> rank_row).zero?
    end
  end

  def honor_sort(other)
    compare = other.points <=> points
    return compare unless compare.zero?

    compare = other.participation_count <=> participation_count
    return compare unless compare.zero?

    compare = best_rank <=> other.best_rank
    return compare unless compare.zero?

    compare = other.best_rank_count <=> best_rank_count
    return compare unless compare.zero?

    sum_time <=> other.sum_time
  end

  def participation_count
    @cups.values.count
  end

  def self.special_sort!(rows)
    honor_rows = rows.select { |row| row.rank.present? && row.rank <= 3 }.sort { |row, other| row.honor_sort(other) }
    honor_rows.each { |row| row.calculate_rank!(honor_rows) }
    rows.sort_by! { |row| row.rank || 999 }
  end

  protected

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

  def calc_participation_count
    4
  end
end
