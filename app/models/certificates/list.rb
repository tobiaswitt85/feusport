# frozen_string_literal: true

class Certificates::List
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :competition, :template_id, :score_result_id, :competition_result_id, :group_score_result_id

  attribute :background_image, :boolean, default: true

  validates :competition, :template, presence: true
  validate :result_present

  def template
    @template ||= competition&.certificates_templates&.find_by(id: template_id)
  end

  def score_result
    @score_result ||= competition&.score_results&.find_by(id: score_result_id)
  end

  def group_score_result
    @group_score_result ||= begin
      result = competition&.score_results&.find_by(id: group_score_result_id)
      Score::GroupResult.new(result) if result
    end
  end

  def competition_result
    @competition_result ||= competition&.score_competition_results&.find_by(id: competition_result_id)
  end

  def result
    @result ||= score_result || competition_result || group_score_result
  end

  def rows
    @rows ||= result&.rows
  end

  def save
    valid?
  end

  private

  def result_present
    return if [score_result, competition_result, group_score_result].count(&:itself) == 1

    errors.add(:score_result_id, :invalid)
    errors.add(:competition_result_id, :invalid)
    errors.add(:group_score_result_id, :invalid)
  end
end
