# frozen_string_literal: true

class CompetitionMailer < ApplicationMailer
  def access_request
    @access_request = params[:access_request]
    mail(
      to: @access_request.email,
      reply_to: email_address_with_name(@access_request.sender.email, @access_request.sender.name),
      subject: "Zugangsanfrage für Wettkampf - #{@access_request.competition.name}",
    )
  end
end
