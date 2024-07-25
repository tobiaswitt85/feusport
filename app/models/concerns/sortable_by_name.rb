# frozen_string_literal: true

module SortableByName
  extend ActiveSupport::Concern

  protected

  def <=>(other)
    sort_by_name = name <=> other.name
    return sort_by_name unless sort_by_name == 0

    to_key <=> other.to_key
  end
end
