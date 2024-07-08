# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Score::ListPrintGenerator do
  let(:competition) { create(:competition) }
  let(:user) { competition.users.first }

  let!(:la) { create(:discipline, :la, competition:) }
  let!(:female) { create(:band, :female, competition:) }
  let!(:assessment_female) { create(:assessment, competition:, discipline: la, band: female) }

  let!(:team_female) { create(:team, band: female, competition:) }

  let(:result_la) { create(:score_result, competition:, assessment: assessment_female) }

  let!(:team_list) { create_score_list(result_la, team_female => :waiting) }

  describe 'manage list print generators' do
    it 'uses CRUD' do
      sign_in user

      get "/#{competition.year}/#{competition.slug}/score/list_print_generators"
      expect(response).to match_html_fixture.with_affix('index-empty')

      expect do
        get "/#{competition.year}/#{competition.slug}/score/list_print_generators/new"
      end.to change(described_class, :count).by(1)
      new_id = described_class.last.id
      expect(response).to redirect_to(
        "/#{competition.year}/#{competition.slug}/score/list_print_generators/#{new_id}/edit",
      )

      follow_redirect!
      expect(response).to match_html_fixture.with_affix('edit')

      patch "/#{competition.year}/#{competition.slug}/score/list_print_generators/#{new_id}",
            params: { score_list_print_generator: { print_list: 'foobar' } }
      expect(response).to match_html_fixture.with_affix('new-with-error').for_status(422)

      patch "/#{competition.year}/#{competition.slug}/score/list_print_generators/#{new_id}",
            params: { score_list_print_generator: {
              print_list: "#{team_list.id}\npage\npage\ncolumn\n#{team_list.id}",
            } }
      follow_redirect!
      expect(response).to match_html_fixture.with_affix('index-one')

      get "/#{competition.year}/#{competition.slug}/score/list_print_generators/#{new_id}"
      expect(response).to redirect_to(
        "/#{competition.year}/#{competition.slug}/score/list_print_generators/#{new_id}.pdf",
      )
      follow_redirect!
      expect(response).to match_pdf_fixture.with_affix('generated')
      expect(response.content_type).to eq(Mime[:pdf])
      expect(response.header['Content-Disposition']).to eq(
        'inline; filename="startlisten.pdf"; ' \
        "filename*=UTF-8''startlisten.pdf",
      )
      expect(response).to have_http_status(:success)

      # preview

      allow(Open3).to receive(:capture2) do |command|
        result = command.match(/\Acd ([^;]+)/)
        File.write("#{result[1].strip}/out.png", 'foobar')
        File.write("#{result[1].strip}/out-0.png", 'foobar0')
        File.write("#{result[1].strip}/out-1.png", 'foobar1')
        File.write("#{result[1].strip}/out-2.png", 'foobar2')
      end

      patch "/#{competition.year}/#{competition.slug}/score/list_print_generators/#{new_id}?preview=1",
            params: { score_list_print_generator: { print_list: team_list.id.to_s } }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq '{"pages":["Zm9vYmFy\\n"]}'

      patch "/#{competition.year}/#{competition.slug}/score/list_print_generators/#{new_id}?preview=1",
            params: { score_list_print_generator: { print_list: "#{team_list.id}\npage" } }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq '{"pages":["Zm9vYmFyMA==\\n","Zm9vYmFyMQ==\\n"]}'
    end
  end
end
