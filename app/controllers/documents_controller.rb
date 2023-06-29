# frozen_string_literal: true

class DocumentsController < ApplicationController
  before_action :load_competition
  authorize_resource :competition
  load_and_authorize_resource :document, through: :competition

  def new
    @document = Document.new(competition: @competition)
  end

  def edit; end

  def create
    @document = Document.new(competition: @competition)
    @document.assign_attributes(document_params)
    if @document.save
      redirect_to competition_path(id: @competition.slug), notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    @document.assign_attributes(document_params)
    if @document.save
      redirect_to competition_path(id: @competition.slug), notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to competition_path(id: @competition.slug), notice: :deleted
  end

  protected

  def load_competition
    @competition = Competition.find_by!(year: params[:year], slug: params[:competition_id])
  end

  def document_params
    params.require(:document).permit(
      :file, :title
    )
  end
end
