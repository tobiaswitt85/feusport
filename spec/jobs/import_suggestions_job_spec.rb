# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportSuggestionsJob do
  describe 'import job' do
    it 'imports entities from feuerwehrsport-statistik.de', :vcr do
      described_class.perform_now

      expect(FireSportStatistics::Person.count).to eq 1
      expect(FireSportStatistics::PersonSpelling.count).to eq 1
      expect(FireSportStatistics::Team.count).to eq 11
      expect(FireSportStatistics::TeamSpelling.count).to eq 7
      expect(FireSportStatistics::TeamAssociation.count).to eq 11

      expect(FireSportStatistics::Person.first.attributes.except('updated_at', 'created_at')).to eq(
        'dummy' => false,
        'first_name' => 'Tom',
        'gender' => 'male',
        'id' => 184,
        'last_name' => 'Gehlert',
        'personal_best_hb' => 1655,
        'personal_best_hb_competition' => '20.07.2022 - Celje, CTIF',
        'personal_best_hl' => 1364,
        'personal_best_hl_competition' => '25.09.2023 - Varna, Pokallauf (Odessos Cup)',
        'personal_best_zk' => 3023,
        'personal_best_zk_competition' => '20.07.2022 - Celje, CTIF',
        'saison_best_hb' => 1674,
        'saison_best_hb_competition' => '23.05.2024 - Ostrowiec Świętokrzyski, Pokallauf',
        'saison_best_hl' => 1404,
        'saison_best_hl_competition' => '23.05.2024 - Ostrowiec Świętokrzyski, Pokallauf',
        'saison_best_zk' => 3078,
        'saison_best_zk_competition' => '23.05.2024 - Ostrowiec Świętokrzyski, Pokallauf',
      )

      expect(Series::Participation.count).to eq 70
      expect(Series::Assessment.count).to eq 16
      expect(Series::Cup.count).to eq 18
      expect(Series::Round.count).to eq 4
    end
  end
end
