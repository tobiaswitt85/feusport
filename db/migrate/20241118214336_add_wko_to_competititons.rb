# frozen_string_literal: true

class AddWkoToCompetititons < ActiveRecord::Migration[7.0]
  def change
    add_reference :competitions, :wko, type: :uuid
    add_foreign_key :competitions, :wkos
  end
end
