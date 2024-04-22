# frozen_string_literal: true

class Competitions::DocumentsController < CompetitionNestedController
  load_and_authorize_resource :document, through: :competition

  def new
    @document = Document.new(competition: @competition)
  end

  def edit; end

  def create
    @document = Document.new(competition: @competition)
    @document.assign_attributes(document_params)
    if @document.save
      redirect_to competition_show_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    @document.assign_attributes(document_params)
    if @document.save
      redirect_to competition_show_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to competition_show_path, notice: :deleted
  end

  protected

  def document_params
    params.require(:document).permit(
      :file, :title
    )
  end
end
