# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competitions::AccessesController do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }
  let(:other_user) { create(:user, :other) }

  describe 'accesses managements' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/accesses"
      expect(response).to match_html_fixture.with_affix('index-one-entry')

      # GET new
      get "/#{competition.year}/#{competition.slug}/access_requests/new"
      expect(response).to match_html_fixture.with_affix('new')

      # POST create with failure
      post "/#{competition.year}/#{competition.slug}/access_requests", params: { user_access_request: { email: 'foo' } }
      expect(response).to match_html_fixture.with_affix('new-error').for_status(422)

      expect do
        # POST create an access_request
        post "/#{competition.year}/#{competition.slug}/access_requests",
             params: { user_access_request: { email: 'foo@bar.de', text: 'Hallo', drop_myself: true } }
        expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/accesses")
        follow_redirect!
      end.to have_enqueued_job.with('CompetitionMailer', 'access_request', 'deliver_now', any_args)

      # GET index
      expect(response).to match_html_fixture.with_affix('index-two-entries')

      # load request
      req = competition.user_access_requests.first

      # GET connect - error same user
      get "/#{competition.year}/#{competition.slug}/access_requests/#{req.id}/connect"
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/accesses")
      expect(flash[:alert]).to eq 'Du kannst dich nicht selber hinzufügen.'

      sign_out user
      sign_in other_user

      expect do
        expect do
          # GET connect
          get "/#{competition.year}/#{competition.slug}/access_requests/#{req.id}/connect"
          expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/accesses")
          expect(flash[:notice]).to eq 'Du wurdest erfolgreich mit dem Wettkampf verbunden.'
        end.not_to change(UserAccess, :count)
      end.to have_enqueued_job.with('CompetitionMailer', 'access_request_connected', 'deliver_now', any_args)

      # POST create an other access_request
      post "/#{competition.year}/#{competition.slug}/access_requests",
           params: { user_access_request: { email: 'foo@bar.de', text: 'Hallo', drop_myself: false } }
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/accesses")

      sign_out other_user
      sign_in user

      # load request
      req = competition.user_access_requests.first

      expect do
        # GET connect
        get "/#{competition.year}/#{competition.slug}/access_requests/#{req.id}/connect"
        expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/accesses")
        expect(flash[:notice]).to eq 'Du wurdest erfolgreich mit dem Wettkampf verbunden.'
      end.to change(UserAccess, :count).by(1)

      # create an other request
      req = UserAccessRequest.create!(competition:, sender: other_user, email: 'foo@bar.de', text: 'Hallo')

      # GET connect with error
      get "/#{competition.year}/#{competition.slug}/access_requests/#{req.id}/connect"
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/accesses")
      expect(flash[:alert]).to eq 'Du hast bereits Zugriff auf diesen Wettkampf.'

      # POST create an other access_request
      post "/#{competition.year}/#{competition.slug}/access_requests",
           params: { user_access_request: { email: 'foo@bar.de', text: 'Hallo', drop_myself: false } }
      expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/accesses")

      # load access
      access = competition.user_access_requests.first

      expect do
        # DELETE destroy
        delete "/#{competition.year}/#{competition.slug}/access_requests/#{access.id}"
        expect(response).to redirect_to("/#{competition.year}/#{competition.slug}/accesses")
        expect(flash[:notice]).to eq :deleted
      end.to change(UserAccessRequest, :count).by(-1)
    end
  end
end
