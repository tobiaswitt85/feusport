# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListFactories::Best do
  let(:competition) { create(:competition) }
  let(:band) { create(:band, :female, competition:) }

  let(:discipline) { create(:discipline, :hl, competition:) }
  let(:assessment) { create(:assessment, competition:, discipline:, band:) }
  let(:before_assessment) { create(:assessment, competition:, discipline:, band:) }
  let(:result) { create(:score_result, competition:, assessment:) }
  let(:before_result) { create(:score_result, competition:, assessment:) }

  let(:list) { create(:score_list, competition:, assessments: [assessment], results: [result]) }

  let(:factory) do
    described_class.new(
      competition:, session_id: '1',
      discipline:, assessments: [assessment], name: 'long name',
      shortcut: 'short', track_count: 2, results: [result],
      before_result:, best_count: 2
    )
  end

  describe '#perform_rows' do
    context 'when not enough rows present' do
      before { allow(factory).to receive(:result_rows).and_return([1]) }

      it 'returns all rows' do
        expect(factory.send(:perform_rows).count).to eq 1
      end
    end

    context 'when result is empty' do
      before { allow(factory).to receive(:result_rows).and_return([]) }

      it 'returns an empty array' do
        expect(factory.send(:perform_rows).count).to eq 0
      end
    end

    context 'when more then best count rows are present' do
      before { allow(factory).to receive(:result_rows).and_return([1, 2, 3, 4]) }

      it 'returns first 2 rows' do
        expect(factory.send(:perform_rows).count).to eq 2
      end

      it 'returns in correct order' do
        expect(factory.send(:perform_rows)).to eq [2, 1]
      end
    end

    context 'when last best row and first row outside the range have same value' do
      before { allow(factory).to receive(:result_rows).and_return([1, 2, 2, 4]) }

      it 'returns one row more' do
        expect(factory.send(:perform_rows).count).to eq 3
      end
    end
  end

  describe 'validation' do
    before { factory.instance_variable_set(:@list, list) }

    it 'is valid' do
      expect(factory).to be_valid
    end

    context 'with other assessment' do
      let(:before_result) { create(:score_result, competition:, assessment: other_assessment) }
      let(:other_assessment) { create(:assessment, competition:, discipline:, band:) }

      it 'compares assessment from list and result' do
        expect(factory).not_to be_valid
        expect(factory.errors.attribute_names).to include(:before_result)
      end
    end
  end
end
