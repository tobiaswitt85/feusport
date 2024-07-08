# frozen_string_literal: true

class Competitions::Deletion
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :competition

  attribute :confirm, :boolean, default: false
  validates :confirm, acceptance: true

  def save
    return false unless valid?

    Competition.transaction do
      competition.score_list_print_generators.destroy_all
      competition.documents.destroy_all
      competition.certificates_templates.destroy_all
      competition.score_competition_results.destroy_all
      competition.score_list_factories.destroy_all
      competition.score_lists.destroy_all
      competition.score_results.destroy_all
      competition.assessments.destroy_all
      competition.teams.destroy_all
      competition.people.destroy_all
      competition.disciplines.destroy_all
      competition.bands.destroy_all

      competition.destroy
    end
  end
end
