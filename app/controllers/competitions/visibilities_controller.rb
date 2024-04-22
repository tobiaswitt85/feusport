# frozen_string_literal: true

class Competitions::VisibilitiesController < CompetitionNestedController
  def edit; end

  def update
    @competition.assign_attributes(competition_params)
    if @competition.save
      redirect_to competition_show_path(slug: @competition.slug, year: @competition.year), notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :edit, status: :unprocessable_entity
    end
  end

  protected

  def competition_params
    params.require(:competition).permit(
      :slug, :visible
    )
  end
end
