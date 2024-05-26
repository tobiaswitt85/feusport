# frozen_string_literal: true

class Competitions::PeopleController < CompetitionNestedController
  default_resource

  def create
    @person.assign_attributes(person_params)
    if @person.save
      redirect_to competition_people_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    @person.assign_attributes(person_params)
    if @person.save
      redirect_to competition_people_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy
    redirect_to competition_people_path, notice: :deleted
  end

  protected

  def person_params
    params.require(:person).permit(
      :bib_number, :first_name, :last_name, :band_id
    )
  end
end
