# frozen_string_literal: true

require 'timeout'

class Score::ListFactories::Simple < Score::ListFactory
  NUMBER_OF_THREADS = 10
  TIMEOUT_PER_MODE = 0.2

  def perform
    tracks = (1..list.track_count).to_a
    restriction_check = TeamListRestriction::Check.new(self)

    rows = assessment_requests.to_a

    stack = nil
    threads = []

    loop do
      begin
        Timeout.timeout(TIMEOUT_PER_MODE) do
          NUMBER_OF_THREADS.times do |thread_index|
            threads[thread_index] = Thread.new do
              t_rows = rows.dup.shuffle
              t_restriction_check = restriction_check.dup

              thread_stack = try_next_track([], t_rows, tracks, t_restriction_check, 0, 1)
              if thread_stack
                stack = thread_stack
                threads.each { |t| t.kill unless t == Thread.current }
              end
            end
          end
          threads.each(&:join)
        end
      rescue Timeout::Error
        threads.each(&:kill)
      end

      break unless stack.nil?

      restriction_check.softer_mode += 1
    end

    transaction do
      stack.each do |entity, run, track|
        create_list_entry(entity, run, track)
      end
    end
  end

  protected

  def try_next_track(stack, rows, tracks, t_restriction_check, track_index, run)
    return false unless t_restriction_check.valid_from_factory?(stack)

    return stack if rows.empty?

    if track_index >= tracks.count
      run += 1
      track_index = 0
    end
    track = tracks[track_index]

    rows.each_with_index do |entity, index|
      stack.push([entity, run, track])

      next_rows = rows.dup.tap { |i| i.delete_at(index) }
      new_stack = try_next_track(stack, next_rows, tracks, t_restriction_check, track_index + 1, run)
      return new_stack unless new_stack == false

      stack.pop
    end

    false
  end
end
