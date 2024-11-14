# frozen_string_literal: true

class AddPublicToCertificatesTemplate < ActiveRecord::Migration[7.0]
  def change
    change_table :certificates_templates, bulk: true do |t|
      t.boolean :importable_for_me, null: false, default: true
      t.boolean :importable_for_others, null: false, default: false
    end

    Certificates::Template.where(name: 'Beispiel-Urkunde (Vorlage)').update_all(importable_for_me: false)
  end
end
