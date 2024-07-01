# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'competitions/score/competition_results' do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  let!(:la) { create(:discipline, :la, competition:) }
  let!(:female) { create(:band, :female, competition:) }
  let!(:assessment_female) { create(:assessment, competition:, discipline: la, band: female) }

  let!(:team_female1) { create(:team, band: female, competition:) }
  let!(:team_female2) { create(:team, band: female, competition:) }

  let(:result_la) { create(:score_result, competition:, assessment: assessment_female) }

  describe 'results managements' do
    it 'uses CRUD' do
      sign_in user

      create_score_list(result_la, team_female1 => 1200, team_female2 => 1300)

      get "/#{competition.year}/#{competition.slug}/score/competition_results"
      expect(response).to match_html_fixture.with_affix('index-empty')

      get "/#{competition.year}/#{competition.slug}/score/competition_results/new"
      expect(response).to match_html_fixture.with_affix('new')

      post "/#{competition.year}/#{competition.slug}/score/competition_results",
           params: { score_competition_result: { name: '' } }
      expect(response).to match_html_fixture.with_affix('new-error').for_status(422)

      expect do
        post "/#{competition.year}/#{competition.slug}/score/competition_results",
             params: { score_competition_result: { name: 'Frauen', hidden: '1', result_type: 'places_to_points',
                                                   result_ids: ['', result_la.id] } }
      end.to change(Score::CompetitionResult, :count).by(1)

      follow_redirect!
      expect(response).to match_html_fixture.with_affix('index-with-hidden')

      result = Score::CompetitionResult.first

      get "/#{competition.year}/#{competition.slug}/score/competition_results/#{result.id}/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      patch "/#{competition.year}/#{competition.slug}/score/competition_results/#{result.id}",
            params: { score_competition_result: { name: '' } }
      expect(response).to match_html_fixture.with_affix('edit-with-error').for_status(422)

      patch "/#{competition.year}/#{competition.slug}/score/competition_results/#{result.id}",
            params: { score_competition_result: { hidden: '0' } }
      expect(response).to redirect_to "/#{competition.year}/#{competition.slug}/score/competition_results"
      follow_redirect!

      expect(response).to match_html_fixture.with_affix('index')

      expect do
        delete "/#{competition.year}/#{competition.slug}/score/competition_results/#{result.id}"
      end.to change(Score::CompetitionResult, :count).by(-1)
    end
  end
end
