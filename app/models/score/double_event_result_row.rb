# frozen_string_literal: true

Score::DoubleEventResultRow = Struct.new(:entity, :result) do
  include Certificates::StorageSupport
  delegate :competition, to: :result
  attr_reader :result_rows

  def add_result_row(result_row)
    @result_rows ||= []
    @result_rows.push(result_row)
  end

  def sum_result_entry
    @sum_result_entry ||= Score::ResultEntry.new(
      time_with_valid_calculation: result_rows.map(&:best_result_entry).sum(&:compare_time),
    )
  end

  def result_entry
    sum_result_entry
  end

  def result_entry_from(result)
    result_rows.select { |row| row.result == result }.map(&:best_result_entry).first
  end

  def <=>(other)
    compare = sum_result_entry <=> other.sum_result_entry
    return compare if compare != 0

    if entity.band.gender.to_s == 'female'
      compare = obstacle_course_time <=> other.obstacle_course_time
      return compare if compare != 0

      climbing_hook_ladder_time <=> other.climbing_hook_ladder_time
    else
      compare = climbing_hook_ladder_time <=> other.climbing_hook_ladder_time
      return compare if compare != 0

      obstacle_course_time <=> other.obstacle_course_time
    end
  end

  def result_rows
    @result_rows.presence || []
  end

  protected

  def climbing_hook_ladder_time
    time_by_discipline('hl')
  end

  def obstacle_course_time
    time_by_discipline('hb')
  end

  def time_by_discipline(discipline_key)
    result_rows.find { |row| row.result.discipline.key == discipline_key }&.best_result_entry
  end
end
