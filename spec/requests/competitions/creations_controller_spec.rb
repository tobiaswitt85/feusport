# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Competition' do
  let(:user) { create(:user) }

  describe 'competition creations' do
    it 'creates competition' do
      sign_in user

      get '/competitions/creations/new'
      expect(response).to match_html_fixture.with_affix('new')

      # POST create with failure
      post '/competitions/creations', params: { competition: { name: 'Foo', date: '', locality: '' } }
      expect(response).to match_html_fixture.with_affix('new-error').for_status(422)

      expect do
        post '/competitions/creations', params: { competition: { name: 'Foo', date: '2024-02-29', locality: 'Berlin' } }
        expect(response).to redirect_to '/2024/foo'
        follow_redirect!
        expect(response).to match_html_fixture.with_affix('showing')
      end.to change(Competition, :count).by(1)

      expect(Competition.first.users).to eq [user]
    end
  end
end
