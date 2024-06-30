# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'competitions/score/results' do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  let!(:hl) { create(:discipline, :hl, competition:) }
  let!(:female) { create(:band, :female, competition:) }
  let!(:assessment_hl_female) { create(:assessment, competition:, discipline: hl, band: female) }

  let(:team) { create(:team, band: female, competition:) }
  let(:person1) { create(:person, :generated, band: female, competition:, team:) }
  let(:person2) { create(:person, :generated, band: female, competition:, team:) }
  let(:person3) { create(:person, :generated, band: female, competition:, team:) }

  describe 'results managements' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/score/results"
      expect(response).to match_html_fixture.with_affix('index-empty')

      get "/#{competition.year}/#{competition.slug}/score/results/new"
      expect(response).to match_html_fixture.with_affix('new')

      post "/#{competition.year}/#{competition.slug}/score/results",
           params: { score_result: { forced_name: '', assessment_id: nil } }
      expect(response).to match_html_fixture.with_affix('new-error').for_status(422)

      expect do
        post "/#{competition.year}/#{competition.slug}/score/results",
             params: { score_result: { forced_name: '', assessment_id: assessment_hl_female.id,
                                       group_assessment: true, group_score_count: 2 } }
      end.to change(Score::Result, :count).by(1)

      follow_redirect!
      expect(response).to match_html_fixture.with_affix('show')

      result = Score::Result.first

      create_score_list(result, person1 => 1200, person2 => 1300, person3 => 1400)

      get "/#{competition.year}/#{competition.slug}/score/results/#{result.id}"
      expect(response).to match_html_fixture.with_affix('show-with-results')

      get "/#{competition.year}/#{competition.slug}/score/results/#{result.id}/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      patch "/#{competition.year}/#{competition.slug}/score/results/#{result.id}",
            params: { score_result: { assessment_id: nil } }
      expect(response).to match_html_fixture.with_affix('edit-with-error').for_status(422)

      patch "/#{competition.year}/#{competition.slug}/score/results/#{result.id}",
            params: { score_result: { forced_name: 'Cooler Name' } }
      expect(response).to redirect_to "/#{competition.year}/#{competition.slug}/score/results/#{result.id}"
      follow_redirect!

      result = Score::Result.find(result.id)

      expect(result.reload.name).to eq 'Cooler Name'

      expect do
        delete "/#{competition.year}/#{competition.slug}/score/results/#{result.id}"
      end.to change(Score::Result, :count).by(-1)
    end
  end
end
