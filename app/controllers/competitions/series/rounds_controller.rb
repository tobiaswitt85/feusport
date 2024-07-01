# frozen_string_literal: true

class Competitions::Series::RoundsController < CompetitionNestedController
  def index
    @rounds = Series::Round.exists_for(@competition).order(:year, :name)
    redirect_to competition_series_round_path(id: @rounds.first.id) if @rounds.count == 1
  end

  def show
    round = Series::Round.find(params[:id])
    @person_assessments = Series::PersonAssessment.where(round:)
    @team_assessments_exists = Series::TeamAssessment.where(round:).present?
    @round = round
    @page_title = "#{@round} - Wettkampfserie"
  end
end
