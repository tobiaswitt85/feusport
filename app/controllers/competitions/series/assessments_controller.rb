# frozen_string_literal: true

class Competitions::Series::AssessmentsController < CompetitionNestedController
  def show
    @assessment = Series::Assessment.find(params[:id])
    @page_title = "#{@assessment.round.name} #{@assessment.name} - Wettkampfserie"
  end
end
