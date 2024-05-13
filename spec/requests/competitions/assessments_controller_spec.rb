# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assessment do
  let(:competition) { create(:competition) }
  let(:user) { competition.user }

  let!(:la) { create(:discipline, :la, competition:) }
  let!(:gs) { create(:discipline, :gs, competition:) }
  let!(:female) { create(:band, :female, competition:) }
  let!(:male) { create(:band, :male, competition:) }

  describe 'assessments managements' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/assessments"
      expect(response).to match_html_fixture.with_affix('index-empty')

      # create an other assessment
      create(:assessment, discipline: gs, band: male, competition:)

      # GET new
      get "/#{competition.year}/#{competition.slug}/assessments/new"
      expect(response).to match_html_fixture.with_affix('new')

      # POST create with failure
      post "/#{competition.year}/#{competition.slug}/assessments", params: { assessment: { name: 'Foo' } }
      expect(response).to match_html_fixture.with_affix('new-error').for_status(422)

      # POST create an own assessment
      post "/#{competition.year}/#{competition.slug}/assessments", params: { assessment: {
        discipline_id: la.id, band_id: female.id
      } }
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/assessments")
      follow_redirect!

      # GET index
      expect(response).to match_html_fixture.with_affix('index-two-entries')

      assessment = described_class.find_by(discipline: la)
      expect(assessment.band).to eq female
      expect(assessment.decorated_name).to eq 'Löschangriff nass - Frauen'

      # GET show
      get "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}"
      expect(response).to match_html_fixture.with_affix('show')

      # GET edit
      get "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      # PUT update with failure
      put "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}",
          params: { assessment: { discipline_id: 'other' } }
      expect(response).to match_html_fixture.with_affix('edit-error').for_status(422)

      # PUT update
      put "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}",
          params: { assessment: { name: 'other' } }
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/assessments")

      assessment = described_class.find_by(discipline: la)
      expect(assessment.decorated_name).to eq 'other'

      expect do
        # DELETE destroy
        delete "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}"
        expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/assessments")
      end.to change(described_class, :count).by(-1)
    end
  end
end
