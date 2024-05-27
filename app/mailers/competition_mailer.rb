# frozen_string_literal: true

class CompetitionMailer < ApplicationMailer
  def test
    @foo = params[:foo]
    mail(to: email_address_with_name('foo@bar.de', 'Foo'), subject: 'Welcome to My Awesome Site')
  end
end
