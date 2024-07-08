# frozen_string_literal: true

class HomeController < ApplicationController
  def home; end
  def info; end

  def disseminators
    authorize!(:visit, :disseminator)

    @disseminators = [
      Disseminator.new(
        'Max Mustermann', 'Mecklenburg-Vorpommern', 'Geschäftsführer des KFV Rostock', 'foo@bar.de', nil
      ),
      Disseminator.new(
        'Maria Mustermann', 'Brandenburg', 'Fachausschuss Wettbewerbe', nil, '0190 123456'
      ),
      Disseminator.new(
        'Fred Peters', 'Sachsen-Anhalt', 'Feuerwehrsportler', 'bar@foo.de', '0190 123123'
      ),
      Disseminator.new(
        'Super Mann', 'Thüringen', 'Organisator aus Taura', 'blub@hans.de', nil
      ),
    ]
  end

  Disseminator = Struct.new(:name, :lfv, :position, :email_address, :phone_number)
end
