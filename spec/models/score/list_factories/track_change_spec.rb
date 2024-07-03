# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListFactories::TrackChange do
  let(:competition) { create(:competition) }
  let(:band) { create(:band, :female, competition:) }

  let(:discipline) { create(:discipline, :hl, competition:) }
  let(:assessment) { create(:assessment, competition:, discipline:, band:) }
  let(:before_assessment) { create(:assessment, competition:, discipline:, band:) }
  let(:result) { create(:score_result, competition:, assessment:) }
  let(:before_result) { create(:score_result, competition:, assessment:) }

  let(:before_list) { create(:score_list, competition:, assessments: [before_assessment], results: [before_result]) }

  let(:factory) do
    described_class.new(
      competition:, session_id: '1',
      discipline:, assessments: [assessment], name: 'long name',
      shortcut: 'short', track_count: 2, results: [result],
      before_list:
    )
  end

  describe 'validation' do
    it 'compares assessment from list and before_list' do
      expect(factory).not_to be_valid
      expect(factory.errors.attribute_names).to include(:before_list)
    end

    context 'with same assessment' do
      let(:before_assessment) { assessment }

      it 'is valid' do
        expect(factory).to be_valid
      end
    end
  end
end
