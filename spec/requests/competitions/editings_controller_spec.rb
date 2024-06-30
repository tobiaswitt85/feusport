# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'competitions/editings' do
  let!(:competition) { create(:competition) }
  let!(:user) { competition.users.first }

  describe 'edit competition' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/editing/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      patch "/#{competition.year}/#{competition.slug}/editing",
            params: { competition: { name: 'Foo', date: '', locality: '', description: 'new-description' } }
      expect(response).to match_html_fixture.with_affix('edit-error').for_status(422)

      patch "/#{competition.year}/#{competition.slug}/editing",
            params: { competition: { name: 'Foo', date: '2024-02-29', locality: 'Berlin',
                                     description: 'new-description' } }

      expect(competition.reload.description).to eq 'new-description'
    end
  end
end
