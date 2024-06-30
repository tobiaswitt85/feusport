# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'competitions/deletions' do
  let!(:competition) { create(:competition) }
  let!(:user) { competition.users.first }

  describe 'destroy competition' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/deletion/new"
      expect(response).to match_html_fixture.with_affix('new')

      post "/#{competition.year}/#{competition.slug}/deletion",
           params: { competitions_deletion: { confirm: '0' } }
      expect(response).to match_html_fixture.with_affix('new-error').for_status(422)

      expect do
        post "/#{competition.year}/#{competition.slug}/deletion",
             params: { competitions_deletion: { confirm: '1' } }
        expect(response).to redirect_to(root_path)
      end.to change(Competition, :count).by(-1)
    end
  end
end
