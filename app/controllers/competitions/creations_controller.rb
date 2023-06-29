# frozen_string_literal: true

class Competitions::CreationsController < ApplicationController
  load_and_authorize_resource :competition

  def new
    @competition = Competition.new(user: current_user)
  end

  def create
    @competition = Competition.new(user: current_user)
    @competition.assign_attributes(competition_params)
    if @competition.save
      redirect_to competition_path(id: @competition.slug, year: @competition.year), notice: :saved
    else
      flash.now[:alert] = :check_errors
      flash.now[:alert] = @competition.errors.inspect
      render action: :new, status: :unprocessable_entity
    end
  end

  protected

  def competition_params
    params.require(:competition).permit(
      :name, :date, :locality
    )
  end
end
