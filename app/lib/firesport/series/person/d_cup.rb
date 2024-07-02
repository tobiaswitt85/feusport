# frozen_string_literal: true

class Firesport::Series::Person::DCup < Firesport::Series::Person::Base
  def self.honor_rank
    10
  end

  def self.max_points(*)
    30
  end
end
