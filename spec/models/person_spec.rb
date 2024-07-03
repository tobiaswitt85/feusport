# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person do
  let(:competition) { create(:competition) }
  let(:female) { create(:band, :female, competition:) }
  let(:male) { create(:band, :male, competition:) }

  describe 'validation' do
    let(:team_male) { build_stubbed(:team, competition:, band: male) }
    let(:team_female) { build_stubbed(:team, competition:, band: female) }

    context 'when team band is not person band' do
      let(:person) { build(:person, competition:, team: team_female, band: male) }

      it 'fails on validation' do
        expect(person).not_to be_valid
        expect(person.errors.attribute_names).to include(:team)
      end
    end

    context 'when team band is person band' do
      let(:person) { build(:person, competition:, team: team_male, band: male) }

      it 'fails on validation' do
        expect(person).to be_valid
      end
    end
  end
end
