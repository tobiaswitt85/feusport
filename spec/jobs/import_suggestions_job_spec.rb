# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportSuggestionsJob do
  describe 'import job' do
    it 'imports entities from feuerwehrsport-statistik.de', :vcr do
      described_class.perform_now

      expect(FireSportStatistics::Person.count).to eq 1
      expect(FireSportStatistics::PersonSpelling.count).to eq 1
      expect(FireSportStatistics::Team.count).to eq 11
      expect(FireSportStatistics::TeamSpelling.count).to eq 2
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
        'saison_best_hb' => nil,
        'saison_best_hb_competition' => nil,
        'saison_best_hl' => 1415,
        'saison_best_hl_competition' => '06.01.2024 - Langengrassau, Pokallauf (Neujahrssteigen)',
        'saison_best_zk' => nil,
        'saison_best_zk_competition' => nil,
      )
    end
  end
end
