# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    competition
    band

    name { "#{band.name}-Team" }
    sequence(:number) { |n| n }
    shortcut { "#{band.name}-T" }
  end

  factory :team_marker do
    competition
    name { 'Angereist?' }
    value_type { 'boolean' }
  end
end
