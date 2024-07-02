# frozen_string_literal: true

class Competitions::ShowingsController < CompetitionNestedController
  def show
    send_pdf(Exports::Pdf::Flyer, args: [@competition])
  end
end
