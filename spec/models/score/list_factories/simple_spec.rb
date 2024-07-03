# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListFactories::Simple do
  let(:competition) { create(:competition) }
  let(:band) { create(:band, :female, competition:) }

  let(:discipline) { create(:discipline, :hl, competition:) }
  let(:assessment) { create(:assessment, competition:, discipline:, band:) }
  let(:result) { create(:score_result, competition:, assessment:) }

  let(:factory) do
    described_class.create(
      competition:, session_id: '1',
      discipline:, assessments: [assessment], name: 'long name',
      shortcut: 'short', track_count: 2, results: [result]
    )
  end

  before do
    create_list(:person, 5, :with_team).each { |person| person.requests.create!(assessment: factory.assessments.first) }
    factory.reload
  end

  describe 'perform' do
    it 'create list entries' do
      factory.list
      expect { factory.perform }.to change(Score::ListEntry, :count).by(5)
    end

    context 'when lottery_numbers given' do
      it 'create list entries' do
        competition.update!(lottery_numbers: true)
        factory.list
        expect { factory.perform }.to change(Score::ListEntry, :count).by(5)
      end
    end
  end
end
