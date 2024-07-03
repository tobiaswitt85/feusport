# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListEntry do
  let(:competition) { create(:competition) }
  let(:band) { create(:band, competition:) }
  let(:assessment) { create(:assessment, competition:, band:) }
  let(:result) { create(:score_result, competition:, assessment:) }
  let(:score_list) { create(:score_list, competition:, assessments: [assessment], results: [result]) }
  let(:score_list_entry) { build(:score_list_entry, list: score_list, assessment:, competition:) }

  describe 'validation' do
    context 'when track count' do
      it 'validates track count from list' do
        expect(score_list_entry).to be_valid
        score_list_entry.track = 5
        expect(score_list_entry).not_to be_valid
        expect(score_list_entry.errors.attribute_names).to include :track
      end
    end

    context 'when edit_second_time_before given' do
      let(:score_list_entry) do
        create(:score_list_entry, list: score_list, assessment:, competition:, edit_second_time: '22.88')
      end

      it 'checks it is the same' do
        expect(score_list_entry.edit_second_time_before).to eq '22.88'
        score_list_entry.edit_second_time = '22.89'

        score_list_entry.edit_second_time_before = '11.33'
        expect(score_list_entry).not_to be_valid
        expect(score_list_entry.errors).to include :changed_while_editing

        score_list_entry.edit_second_time_before = '22.88'
        expect(score_list_entry).to be_valid

        score_list_entry.edit_second_time_before = nil
        expect(score_list_entry).to be_valid
      end
    end
  end
end
