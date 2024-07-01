# frozen_string_literal: true

class Competitions::Series::AssessmentsController < CompetitionNestedController
  def show
    @assessment = Series::Assessment.find(params[:id])
    @person_assessments = Series::PersonAssessment.where(round: @assessment.round).where.not(id: @assessment.id)
    @page_title = "#{@assessment.round.name} #{@assessment.name} - Wettkampfserie"
  end
end
