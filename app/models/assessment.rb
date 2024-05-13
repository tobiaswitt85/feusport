# frozen_string_literal: true

class Assessment < ApplicationRecord
  schema_validations
  belongs_to :competition
  belongs_to :discipline
  belongs_to :band

  def decorated_name
    @decorated_name ||= name.presence || [discipline&.name, band&.name].compact_blank.join(' - ')
    # name.presence || ([discipline&.name, band&.name] + tag_names).compact_blank.join(' - ')
  end

  def destroy_possible?
    true || results.empty?
  end

  def <=>(other)
    sort_by_name = decorated_name <=> other.decorated_name
    return sort_by_name unless sort_by_name == 0

    super
  end
end
