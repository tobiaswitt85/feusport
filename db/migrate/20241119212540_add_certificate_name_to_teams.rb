# frozen_string_literal: true

class AddCertificateNameToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :certificate_name, :string
  end
end
