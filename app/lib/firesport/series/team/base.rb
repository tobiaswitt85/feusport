# frozen_string_literal: true

Firesport::Series::Team::Base = Struct.new(:round, :team, :team_number) do
  attr_reader :rank

  def self.honor_rank
    3
  end

  def self.points_for_result(rank, _time, round, gender:, double_rank_count: 0)
    [max_points(round, gender:) + 1 - rank - double_rank_count, 0].max
  end

  def initialize(*args)
    super(*args)
    @rank = 0
  end

  delegate :id, to: :team, prefix: true

  def name_with_number
    "#{team&.name} #{team_number}"
  end

  def best_result_entry
    @best_result_entry ||= Score::ResultEntry.new(time_with_valid_calculation: best_time).human_time
  end

  def add_participation(participation)
    @cups ||= {}
    @cups[participation.cup_id] ||= []
    @cups[participation.cup_id].push(participation)
  end

  def participations_for_cup(cup)
    @cups ||= {}
    (@cups[cup.id] || []).sort_by(&:assessment)
  end

  def points_for_cup(cup)
    @cups ||= {}
    @cups[cup.id] ||= []
    @cups[cup.id].sum(&:points)
  end

  def count
    @cups ||= {}
    @cups.values.count
  end

  def points
    @cups.values.sum { |cup| cup.sum(&:points) }
  end

  def best_time
    @best_time ||= @cups.values.flatten.select { |p| p.assessment.discipline == 'la' }.map(&:time).min
  end

  def best_time_without_nil
    best_time || (Firesport::INVALID_TIME + 1)
  end

  def <=>(other)
    other.points <=> points
  end

  def self.special_sort!(_rows); end

  def calculate_rank!(other_rows)
    other_rows.each_with_index do |rank_row, rank|
      return @rank = (rank + 1) if (self <=> rank_row).zero?
    end
  end
end
