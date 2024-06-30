# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'competitions/score/runs' do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  let!(:hl) { create(:discipline, :hl, competition:) }
  let!(:female) { create(:band, :female, competition:) }
  let!(:assessment_hl_female) { create(:assessment, competition:, discipline: hl, band: female) }

  let!(:team_female) { create(:team, band: female, competition:) }

  let(:result_hl) { create(:score_result, competition:, assessment: assessment_hl_female) }
  let(:person1) { create(:person, :generated, competition:) }
  let(:person2) { create(:person, :generated, competition:) }

  describe 'edit run' do
    let!(:person_list) { create_score_list(result_hl, person1 => :waiting, person2 => :waiting) }

    it 'shows form and updates' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}/runs/1/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      entries = person_list.entries

      patch "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}/runs/1",
            params: { score_run: { list_entries_attributes: {
              '0' => {
                'id' => entries[0].id,
                'track' => '1', 'edit_second_time' => '12.23', 'edit_second_time_before' => '12',
                'result_type_before' => 'waiting', 'result_type' => 'valid'
              },
              '1' => {
                'id' => entries[1].id,
                'track' => '2', 'edit_second_time' => '13.44', 'edit_second_time_before' => '',
                'result_type_before' => 'waiting', 'result_type' => 'valid'
              },
            } } }
      expect(response).to match_html_fixture.with_affix('edit-with-error').for_status(422)

      patch "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}/runs/1",
            params: { score_run: { list_entries_attributes: {
              '0' => {
                'id' => entries[0].id,
                'track' => '1', 'edit_second_time' => '12.23', 'edit_second_time_before' => '',
                'result_type_before' => 'waiting', 'result_type' => 'valid'
              },
              '1' => {
                'id' => entries[1].id,
                'track' => '2', 'edit_second_time' => '13.44', 'edit_second_time_before' => '',
                'result_type_before' => 'waiting', 'result_type' => 'valid'
              },
            } } }

      expect(response).to redirect_to(
        "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}#jump-run-1",
      )
    end
  end
end
