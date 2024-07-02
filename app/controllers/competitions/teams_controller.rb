# frozen_string_literal: true

class Competitions::TeamsController < CompetitionNestedController
  default_resource

  def index
    send_pdf(Exports::Pdf::Teams, args: [@competition])
    send_xlsx(Exports::Xlsx::Teams, args: [@competition])
  end

  def create
    @team.assign_attributes(team_params)
    if @team.save
      redirect_to competition_team_path(id: @team.id), notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    @team.assign_attributes(team_params)
    if @team.save
      redirect_to competition_team_path(id: @team.id), notice: :saved
    else
      flash.now[:alert] = :check_errors
      if params[:form] == 'edit_assessment_requests'
        render action: :edit_assessment_requests, status: :unprocessable_entity
      else
        render action: :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @team.destroy
    redirect_to competition_teams_path, notice: :deleted
  end

  protected

  def team_params
    params.require(:team).permit(
      :name, :shortcut, :number, :band_id, :fire_sport_statistics_team_id,
      tags: [],
      requests_attributes: %i[assessment_type relay_count _destroy assessment_id id]
    )
  end

  def assign_new_resource
    self.resource_instance = resource_class.new(competition: @competition, band: Band.find(params[:band_id]))
  end
end
