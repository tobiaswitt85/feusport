# frozen_string_literal: true

class AddUserToTeamsAndPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :applicant_id, :uuid
    add_foreign_key :teams, :users, column: :applicant_id
    add_column :teams, :registration_hint, :text

    add_column :people, :applicant_id, :uuid
    add_foreign_key :people, :users, column: :applicant_id
    add_column :people, :registration_hint, :text
  end
end
