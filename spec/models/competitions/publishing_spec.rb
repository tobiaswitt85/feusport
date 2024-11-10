# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competitions::Publishing do
  let!(:competition_not_visible) { create(:competition, date: 10.days.ago, visible: false) }
  let!(:competition_not_yet) { create(:competition, date: Date.current, visible: true) }
  let!(:competition_remind) { create(:competition, date: 10.days.ago, visible: true) }

  describe 'ReminderJob' do
    it 'delivers mails to unpublished competitions' do
      expect do
        Competitions::Publishing::ReminderJob.perform_now
      end.to have_enqueued_job.with('CompetitionMailer', 'publishing_reminder', 'deliver_now',
                                    { params: { competition: competition_remind }, args: [] })
    end
  end
end
