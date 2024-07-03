# frozen_string_literal: true

class Score::ListFactories::FireRelay < Score::ListFactory
  RelayRequest = Struct.new(:entity, :assessment_type, :assessment)

  def self.generator_possible?(discipline)
    discipline.like_fire_relay?
  end

  def preview_entries_count
    assessment_requests.sum(&:relay_count)
  end

  protected

  def perform_rows
    number_requests = {}
    assessment_requests.each do |request|
      (1..request.relay_count).each do |number|
        number_requests[number] ||= []
        relay = TeamRelay.find_or_create_by!(team: request.entity, number:)
        number_requests[number].push(
          RelayRequest.new(relay, request.assessment_type, request.assessment),
        )
      end
    end
    number_requests.values.flatten
  end
end
