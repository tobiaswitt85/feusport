# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Band do
  describe 'tags' do
    let(:competition) { create(:competition) }
    let(:band) { described_class.new(competition:, gender: :male, name: 'Test') }

    it 'splits and joins tags' do
      band.person_tag_names = 'foo, bar,     blub, HU HA'
      expect(band.person_tags).to contain_exactly('foo', 'bar', 'blub', 'HU HA')

      band.team_tag_names = 'foo1, bar1,     blub1, HU HA1'
      expect(band.team_tags).to contain_exactly('foo1', 'bar1', 'blub1', 'HU HA1')

      band.save!

      id = band.id
      band = described_class.find(id)

      expect(band.person_tags).to contain_exactly('foo', 'bar', 'blub', 'HU HA')
      expect(band.person_tag_names).to eq 'HU HA, bar, blub, foo'
      expect(band.team_tags).to contain_exactly('foo1', 'bar1', 'blub1', 'HU HA1')
      expect(band.team_tag_names).to eq 'HU HA1, bar1, blub1, foo1'
    end
  end
end
