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
      post "/#{competition.year}/#{competition.slug}/assessments", params: { assessment: { forced_name: 'Foo' } }
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
      expect(assessment.name).to eq 'Löschangriff nass - Frauen'

      # GET index XLSX
      get "/#{competition.year}/#{competition.slug}/assessments.xlsx"
      expect(response.content_type).to eq(Mime[:xlsx])
      expect(response.header['Content-Disposition']).to eq(
        "attachment; filename=\"wertungen.xlsx\"; filename*=UTF-8''wertungen.xlsx",
      )
      expect(response).to have_http_status(:success)

      # GET index PDF
      get "/#{competition.year}/#{competition.slug}/assessments.pdf"
      expect(response).to match_pdf_fixture.with_affix('index-as-pdf')
      expect(response.content_type).to eq(Mime[:pdf])
      expect(response.header['Content-Disposition']).to eq(
        "inline; filename=\"wertungen.pdf\"; filename*=UTF-8''wertungen.pdf",
      )
      expect(response).to have_http_status(:success)

      # GET show
      get "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}"
      expect(response).to match_html_fixture.with_affix('show')

      # GET edit
      get "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      # PUT update with failure
      put "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}",
          params: { assessment: { discipline_id: 'not-exists' } }
      expect(response).to match_html_fixture.with_affix('edit-error').for_status(422)

      # PUT update
      put "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}",
          params: { assessment: { forced_name: 'other' } }
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/assessments")

      assessment = described_class.find_by(discipline: la)
      expect(assessment.name).to eq 'other'

      expect do
        # DELETE destroy
        delete "/#{competition.year}/#{competition.slug}/assessments/#{assessment.id}"
        expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/assessments")
      end.to change(described_class, :count).by(-1)
    end
  end
end
