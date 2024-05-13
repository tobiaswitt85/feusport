# frozen_string_literal: true

class Competitions::AssessmentsController < CompetitionNestedController
  default_resource

  def index
    send_pdf(Exports::Pdf::Assessments, args: [@competition])
    send_xlsx(Exports::Xlsx::Assessments, args: [@competition])
  end

  def create
    @assessment.assign_attributes(assessment_params)
    if @assessment.save
      redirect_to competition_assessments_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    @assessment.assign_attributes(assessment_params)
    if @assessment.save
      redirect_to competition_assessments_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @assessment.destroy
    redirect_to competition_assessments_path, notice: :deleted
  end

  protected

  def assessment_params
    params.require(:assessment).permit(
      :forced_name, :discipline_id, :band_id
    )
  end
end
