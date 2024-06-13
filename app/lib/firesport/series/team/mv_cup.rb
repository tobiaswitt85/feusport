# frozen_string_literal: true

class Firesport::Series::Team::MvCup < Firesport::Series::Team::LaCup
  def self.max_points(*)
    15
  end
end
