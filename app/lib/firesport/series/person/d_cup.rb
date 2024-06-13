# frozen_string_literal: true

class Firesport::Series::Person::DCup < Firesport::Series::Person::Base
  def self.honor_rank
    10
  end

  def self.max_points(_round, gender:)
    30
  end

  def self.assessment_disciplines
    { hb: ['', 'U20'], hw: ['', 'U20'], hl: ['', 'U20'], zk: ['', 'U20'], zw: ['', 'U20'] }
  end
end
