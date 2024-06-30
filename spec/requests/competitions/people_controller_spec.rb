# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'People' do
  let!(:competition) { create(:competition) }
  let!(:band) { create(:band, competition:) }
  let!(:hl) { create(:discipline, :hl, competition:) }
  let!(:assessment) { create(:assessment, competition:, discipline: hl, band:) }
  let!(:user) { competition.users.first }

  describe 'People managements' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/people"
      expect(response).to match_html_fixture.with_affix('index-empty')

      get "/#{competition.year}/#{competition.slug}/people/new?band_id=#{band.id}"
      expect(response).to match_html_fixture.with_affix('new')

      post "/#{competition.year}/#{competition.slug}/people",
           params: { band_id: band.id,
                     person: { first_name: 'first-name', last_name: '', team_id: '', create_team_name: '' } }
      expect(response).to match_html_fixture.with_affix('new-with-errors').for_status(422)

      expect do
        expect do
          post "/#{competition.year}/#{competition.slug}/people",
               params: { band_id: band.id,
                         person: { first_name: 'first-name', last_name: 'last-name', team_id: '',
                                   create_team_name: 'new team' } }
          follow_redirect!
          expect(response).to match_html_fixture.with_affix('show')
        end.to change(Person, :count).by(1)
      end.to change(Team, :count).by(1)

      new_id = Person.last.id

      get "/#{competition.year}/#{competition.slug}/people"
      expect(response).to match_html_fixture.with_affix('index-with-one')

      get "/#{competition.year}/#{competition.slug}/people/#{new_id}/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      patch "/#{competition.year}/#{competition.slug}/people/#{new_id}",
            params: { person: { first_name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)

      patch "/#{competition.year}/#{competition.slug}/people/#{new_id}",
            params: { person: { first_name: 'new-name' } }
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/people/#{new_id}")
      expect(Person.find(new_id).first_name).to eq('new-name')

      expect do
        delete "/#{competition.year}/#{competition.slug}/people/#{new_id}"
      end.to change(Person, :count).by(-1)
    end
  end
end
