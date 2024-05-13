# frozen_string_literal: true

class Assessment < ApplicationRecord
  include SortableByName

  schema_validations
  belongs_to :competition
  belongs_to :discipline
  belongs_to :band

  def name
    @name ||= forced_name.presence || [discipline&.name, band&.name].compact_blank.join(' - ')
    # name.presence || ([discipline&.name, band&.name] + tag_names).compact_blank.join(' - ')
  end

  def destroy_possible?
    true || results.empty?
  end
end
