# frozen_string_literal: true

class CompetitionsController < ApplicationController
  before_action :load_competition
  authorize_resource :competition

  def show; end
  def edit; end

  def update
    @competition.assign_attributes(competition_params)
    if @competition.save
      redirect_to competition_path(id: @competition.slug, year: @competition.year), notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @competition.destroy
    redirect_to competitions_path, notice: :deleted
  end

  protected

  def load_competition
    @competition = Competition.find_by!(year: params[:year], slug: params[:id])
  end

  def competition_params
    params.require(:competition).permit(
      :name, :date, :locality, :description
    )
  end
end
