# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'competitions/visibilities' do
  let!(:competition) { create(:competition, visible: false) }
  let!(:user) { competition.users.first }
  let!(:other_user) { create(:user, :other) }

  describe 'edit visibilities' do
    it 'uses CRUD' do
      get "/#{competition.year}/#{competition.slug}"
      expect(response).to redirect_to '/users/sign_in'
      expect(flash[:alert]).to eq 'Bitte melden Dich an, um diese Funktion nutzen zu können.'
      expect(session[:requested_url_before_login]).to eq '/2024/mv-cup'

      get '/competitions/creations/new'
      expect(response).to redirect_to '/users/sign_in?info_hint=competition'
      expect(flash[:alert]).to eq 'Bitte melden Dich an, um diese Funktion nutzen zu können.'
      expect(session[:requested_url_before_login]).to eq '/competitions/creations/new'

      sign_in other_user

      get "/#{competition.year}/#{competition.slug}"
      expect(response).to redirect_to '/'
      expect(flash[:alert]).to eq 'Zugriff verweigert'
    end
  end
end
