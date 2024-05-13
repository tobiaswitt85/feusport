# frozen_string_literal: true

FactoryBot.define do
  factory :discipline do
    Discipline::DISCIPLINES.each do |dkey|
      trait(dkey) do
        name { Discipline::DEFAULT_NAMES[dkey] }
        short_name { dkey.upcase }
        key { dkey }
        single_discipline { Discipline::DEFAULT_SINGLE_DISCIPLINES[dkey] }
        like_fire_relay { dkey == 'fs' }
      end
    end
  end
end
