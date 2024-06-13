# frozen_string_literal: true

class Firesport::Series::Team::SachsenCup < Firesport::Series::Team::LaCup
  def self.max_points(_round, gender:)
    10
  end

  def self.points_for_result(rank, time, round, gender:, double_rank_count: 0)
    if rank == 1
      max_points(round, gender:) - double_rank_count
    elsif rank == 2
      max_points(round, gender:) - 2 - double_rank_count
    else
      super(rank + 2, time, round, double_rank_count:)
    end
  end

  protected

  def calc_participation_count
    round.full_cup_count
  end
end
