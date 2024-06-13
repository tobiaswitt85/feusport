# frozen_string_literal: true

class Firesport::Series::Team::VierBahnenPokal < Firesport::Series::Team::LaCup
  def self.points_for_result(rank, _time, _round, double_rank_count: 0, gender:)
    rank == 1 ? 0 : rank
  end

  def <=>(other)
    compare = points <=> other.points
    return compare unless compare.zero?

    compare = other.participation_count <=> participation_count
    return compare unless compare.zero?

    sum_time <=> other.sum_time
  end

  def points
    @points ||= begin
      fail_points = ((round.full_cup_count || 5) - count) * 20
      ordered_participations.map(&:points).sum + fail_points
    end
  end

  def calculate_rank!(other_rows)
    current_rank = 0
    other_rows.each do |rank_row|
      current_rank += 1
      return @rank = current_rank if (self <=> rank_row).zero?
    end
  end

  def honor_sort(other)
    compare = points <=> other.points
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

  def calc_participation_count
    round.full_cup_count
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
end
