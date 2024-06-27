# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::List do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  let!(:la) { create(:discipline, :la, competition:) }
  let!(:hl) { create(:discipline, :hl, competition:) }
  let!(:female) { create(:band, :female, competition:) }
  let!(:male) { create(:band, :male, competition:) }
  let!(:assessment_male) { create(:assessment, competition:, discipline: la, band: male) }
  let!(:assessment_female) { create(:assessment, competition:, discipline: la, band: female) }
  let!(:assessment_hl_female) { create(:assessment, competition:, discipline: hl, band: female) }

  let!(:team_female) { create(:team, band: female, competition:) }
  let!(:team_male1) { create(:team, band: male, competition:) }
  let!(:team_male2) { create(:team, band: male, competition:) }

  let(:result_hl) { create(:score_result, competition:, assessment: assessment_hl_female) }
  let(:result_la) { create(:score_result, competition:, assessment: assessment_female) }
  let(:person1) { create(:person, :generated, competition:) }
  let(:person2) { create(:person, :generated, competition:) }
  let(:person3) { create(:person, :generated, competition:) }

  describe 'create lists' do
    it 'uses list factory' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/score/lists"
      expect(response).to match_html_fixture.with_affix('index-empty')

      get "/#{competition.year}/#{competition.slug}/score/list_factories/new"
      expect(response).to match_html_fixture.with_affix('new')

      post "/#{competition.year}/#{competition.slug}/score/list_factories",
           params: { score_list_factory: { discipline_id: la.id,
                                           next_step: 'assessments' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-assessments')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { assessment_ids: [assessment_male.id, assessment_female.id],
                                            next_step: 'names' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-names')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { name: 'Löschangriff Nass - Lauf 1', shortcut: 'Lauf 1',
                                            next_step: 'tracks' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-tracks')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { track_count: '2',
                                            next_step: 'results' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-results-no-results')

      result_male = create(:score_result, competition:, assessment: assessment_male)
      result_female = create(:score_result, competition:, assessment: assessment_female)

      get "/#{competition.year}/#{competition.slug}/score/list_factories/edit"
      expect(response).to match_html_fixture.with_affix('new-results')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { result_ids: [result_male.id, result_female.id],
                                            next_step: 'generator' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-generator')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { type: 'Score::ListFactories::TrackChange',
                                            next_step: 'generator_params' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-generator_params_track_change')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { type: 'Score::ListFactories::TrackSame',
                                            next_step: 'generator_params' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-generator_params_track_same')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { type: 'Score::ListFactories::Best',
                                            next_step: 'generator_params' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-generator_params_best')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { type: 'Score::ListFactories::Simple',
                                            next_step: 'generator_params' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-generator_params_single')

      patch "/#{competition.year}/#{competition.slug}/score/list_factories",
            params: { score_list_factory: { next_step: 'finish' } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('new-finish')

      expect do
        patch "/#{competition.year}/#{competition.slug}/score/list_factories",
              params: { score_list_factory: { hidden: '1', separate_target_times: '1', show_best_of_run: '1',
                                              next_step: 'create' } }
        follow_redirect!
      end.to change(Score::ListEntry, :count).by(3)
    end
  end

  describe 'edit list' do
    let!(:person_list) { create_score_list(result_hl, person1 => :waiting, person2 => :waiting, person3 => :waiting) }
    let!(:team_list) { create_score_list(result_la, team_female => :waiting) }

    it 'shows form and updates' do
      sign_in user

      person_list.update!(hidden: true)

      get "/#{competition.year}/#{competition.slug}/score/lists"
      expect(response).to match_html_fixture.with_affix('index-with-two')

      get "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}"
      expect(response).to match_html_fixture.with_affix('show-person')

      get "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}/edit"
      expect(response).to match_html_fixture.with_affix('edit-person')

      patch "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}",
            params: { score_list: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)

      patch "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}",
            params: { score_list: { name: 'new name' } }
      follow_redirect!

      expect(person_list.reload.name).to eq 'new name'

      get "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}/edit_times"
      expect(response).to match_html_fixture.with_affix('edit-times-person')

      entries = person_list.reload.entries
      patch "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}",
            params: { score_list: { entries_attributes: {
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
              '2' => {
                'id' => entries[2].id,
                'track' => '1', 'edit_second_time' => '13.44', 'edit_second_time_before' => '',
                'result_type_before' => 'waiting', 'result_type' => 'valid'
              },
            } } }
      expect(response).to match_html_fixture.with_affix('edit-times-db-changed').for_status(422)

      patch "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}",
            params: { score_list: { entries_attributes: {
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
              '2' => {
                'id' => entries[2].id,
                'track' => '1', 'edit_second_time' => '13.44', 'edit_second_time_before' => '',
                'result_type_before' => 'waiting', 'result_type' => 'valid'
              },
            } } }
      follow_redirect!

      get "/#{competition.year}/#{competition.slug}/score/lists/#{team_list.id}"
      expect(response).to match_html_fixture.with_affix('show-team')

      get "/#{competition.year}/#{competition.slug}/score/lists/#{team_list.id}?destroy_index=1"
      expect(response).to match_html_fixture.with_affix('show-team-with-destroy')

      get "/#{competition.year}/#{competition.slug}/score/lists/#{team_list.id}/" \
          "destroy_entity/#{team_list.entries.first.id}"
      expect(response).to match_html_fixture.with_affix('show-team-destroy-dialog')

      expect do
        patch "/#{competition.year}/#{competition.slug}/score/lists/#{team_list.id}",
              params: { score_list: { entries_attributes: {
                '0' => { '_destroy' => '1', 'id' => team_list.entries.first.id },
              } } }
      end.to change(Score::ListEntry, :count).by(-1)

      expect do
        delete "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}"
      end.to change(described_class, :count).by(-1)
    end
  end

  describe 'move list' do
    let!(:person_list) { create_score_list(result_hl, person1 => :waiting, person2 => :waiting, person3 => :waiting) }

    it 'moves entries' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}/move"
      expect(response).to match_html_fixture.with_affix('move')

      entries = person_list.reload.entries
      new_order = {
        '0' => nil,
        '1' => entries[1].id,
        '2' => entries[0].id,
        '3' => entries[2].id,
        '4' => nil,
        '5' => nil,
      }

      post "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}/move",
           params: {
             save: false,
             new_order:,
             list: { new_order:, save: false },
           }
      expect(response).to match_html_fixture.with_affix('move-new-order')

      post "/#{competition.year}/#{competition.slug}/score/lists/#{person_list.id}/move",
           params: {
             save: true,
             new_order:,
             list: { new_order:, save: true },
           }
      expect(entries[0].reload.run).to eq 2
    end
  end
end
