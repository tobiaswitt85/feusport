# frozen_string_literal: true

class Competitions::TeamsController < CompetitionNestedController
  default_resource

  def create
    @team.assign_attributes(team_params)
    if @team.save
      redirect_to competition_teams_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    @team.assign_attributes(team_params)
    if @team.save
      redirect_to competition_teams_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to competition_teams_path, notice: :deleted
  end

  protected

  def team_params
    params.require(:team).permit(
      :name, :gender
    )
  end
end
