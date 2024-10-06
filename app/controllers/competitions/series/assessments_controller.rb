# frozen_string_literal: true

class Competitions::Series::AssessmentsController < CompetitionNestedController
  def show
    @assessment = Series::Assessment.find(params[:id])

    send_pdf(Exports::Pdf::Series::Assessment, args: [@assessment, @competition]) && return

    @page_title = "#{@assessment.round.name} #{@assessment.name} - Wettkampfserie"
  end
end
