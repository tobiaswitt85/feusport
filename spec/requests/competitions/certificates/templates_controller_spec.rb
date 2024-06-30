# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'competitions/certificates/templates' do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  describe 'manage templates' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/certificates/templates"
      expect(response).to match_html_fixture.with_affix('index-empty')

      get "/#{competition.year}/#{competition.slug}/certificates/templates/new"
      expect(response).to match_html_fixture.with_affix('new')

      post "/#{competition.year}/#{competition.slug}/certificates/templates",
           params: { certificates_template: { name: '' } }
      expect(response).to match_html_fixture.with_affix('new-with-error').for_status(422)

      expect do
        post "/#{competition.year}/#{competition.slug}/certificates/templates",
             params: { certificates_template: { name: 'Urkunde' } }
        follow_redirect!
        expect(response).to match_html_fixture.with_affix('show')
      end.to change(Certificates::Template, :count).by(1)

      new_id = Certificates::Template.last.id

      get "/#{competition.year}/#{competition.slug}/certificates/templates/#{new_id}/edit"
      expect(response).to match_html_fixture.with_affix('edit')

      patch "/#{competition.year}/#{competition.slug}/certificates/templates/#{new_id}",
            params: { certificates_template: { name: '' } }
      expect(response).to match_html_fixture.with_affix('edit-with-error').for_status(422)

      expect(Certificates::Template.find(new_id).image).not_to be_present

      patch "/#{competition.year}/#{competition.slug}/certificates/templates/#{new_id}",
            params: { certificates_template: { name: 'Urkunde2', image: fixture_file_upload('pixel.jpg') } }
      expect(response).to redirect_to "/#{competition.year}/#{competition.slug}/certificates/templates/#{new_id}"

      expect(Certificates::Template.find(new_id).image).to be_present

      expect do
        get "/#{competition.year}/#{competition.slug}/certificates/templates/#{new_id}/duplicate"
      end.to change(Certificates::Template, :count).by(1)
      expect(flash[:info]).to eq 'Duplikat erstellt'

      dup_id = Certificates::Template.where.not(id: new_id).last.id
      expect(response).to redirect_to "/#{competition.year}/#{competition.slug}/certificates/templates/#{dup_id}"

      get "/#{competition.year}/#{competition.slug}/certificates/templates/#{new_id}/remove_file?type=image"
      expect(response).to redirect_to "/#{competition.year}/#{competition.slug}/certificates/templates/#{new_id}"

      expect(Certificates::Template.find(new_id).image).not_to be_present

      expect do
        delete "/#{competition.year}/#{competition.slug}/certificates/templates/#{new_id}"
      end.to change(Certificates::Template, :count).by(-1)
    end
  end
end
