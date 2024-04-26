# frozen_string_literal: true

class Assessment < ApplicationRecord
  schema_validations
  belongs_to :competition
  belongs_to :discipline
  belongs_to :band

  def decorated_name
    name.presence || ([discipline&.name, band&.name] + tag_names).compact_blank.join(' - ')
  end

  def destroy_possible?
    true || results.empty?
  end
end
