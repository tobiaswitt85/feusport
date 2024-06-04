# frozen_string_literal: true

class Score::ListFactories::LotteryNumber < Score::ListFactory
  def self.generator_possible?(discipline)
    !discipline.single_discipline? && discipline.competition.lottery_numbers? && !discipline.like_fire_relay?
  end

  protected

  def perform_rows
    assessment_requests
  end
end
