# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::List do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  let!(:la) { create(:discipline, :la, competition:) }
  let!(:female) { create(:band, :female, competition:) }
  let!(:male) { create(:band, :male, competition:) }
  let!(:assessment_male) { create(:assessment, competition:, discipline: la, band: male) }
  let!(:assessment_female) { create(:assessment, competition:, discipline: la, band: female) }

  let!(:team_female) { create(:team, band: female) }
  let!(:team_male1) { create(:team, band: male) }
  let!(:team_male2) { create(:team, band: male) }

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
end
