# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  def tag_names=(names)
    self.tags = names.to_s.split(',').map(&:strip).compact_blank
  end

  def tag_names
    (tags || []).sort.join(', ')
  end

  def include_tags?(other_tags)
    other_tags.all? { |tag| tags.include?(tag) }
  end
end
