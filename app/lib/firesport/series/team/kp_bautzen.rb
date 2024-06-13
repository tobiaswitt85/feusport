# frozen_string_literal: true

class Firesport::Series::Team::KPBautzen < Firesport::Series::Team::LaCup
  def self.max_points(_round, gender:)
    10
  end

  def calc_participation_count
    4
  end
end
