# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompetitionMailer do
  describe 'access_request' do
    let(:access_request) { create(:user_access_request) }
    let(:mail) { described_class.with(access_request:).access_request }

    it 'renders the headers and body' do
      expect(mail.subject).to eq('Zugangsanfrage für Wettkampf - MV-Cup')
      expect(mail.header[:to].to_s).to eq 'access@request.de'
      expect(mail.header[:from].to_s).to eq 'Feuerwehrsport <no-reply@feusport.de>'
      expect(mail.header[:cc].to_s).to eq ''
      expect(mail.header[:reply_to].to_s).to eq 'Alfred Meier <alfred@meier.de>'
      expect(mail).to match_html_fixture
    end
  end

  describe 'registration_team' do
    let(:competition) { create(:competition) }
    let(:band) { create(:band, competition:) }
    let(:applicant) { create(:user, :other) }
    let(:team) { create(:team, competition:, band:, applicant:, registration_hint: "foo\nbar") }
    let(:mail) { described_class.with(team:).registration_team }

    it 'renders the headers and body' do
      expect(mail.subject).to eq('Neue Wettkampfanmeldung - MV-Cup')
      expect(mail.header[:to].to_s).to eq 'Alfred Meier <alfred@meier.de>'
      expect(mail.header[:from].to_s).to eq 'Feuerwehrsport <no-reply@feusport.de>'
      expect(mail.header[:cc].to_s).to eq ''
      expect(mail.header[:reply_to].to_s).to eq ''
      expect(mail).to match_html_fixture
    end
  end

  describe 'registration_person' do
    let(:competition) { create(:competition) }
    let(:band) { create(:band, competition:) }
    let(:applicant) { create(:user, :other) }
    let(:person) { create(:person, competition:, band:, applicant:, registration_hint: "foo\nbar") }
    let(:mail) { described_class.with(person:).registration_person }

    it 'renders the headers and body' do
      expect(mail.subject).to eq('Neue Wettkampfanmeldung - MV-Cup')
      expect(mail.header[:to].to_s).to eq 'Alfred Meier <alfred@meier.de>'
      expect(mail.header[:from].to_s).to eq 'Feuerwehrsport <no-reply@feusport.de>'
      expect(mail.header[:cc].to_s).to eq ''
      expect(mail.header[:reply_to].to_s).to eq ''
      expect(mail).to match_html_fixture
    end
  end
end
