# frozen_string_literal: true

module Score::ListsHelper
  include Exports::ScoreLists

  def list_entry_options(list, track, entry, best_of_run)
    options = { class: [] }
    options[:class].push('next-run') if track == list.track_count
    options[:data] = { id: entry.id } if entry.present?
    options[:class].push('success') if best_of_run
    options
  end

  def preset_value_for(field, value)
    @score_list.send(field).blank? ? { value: } : {}
  end
end
