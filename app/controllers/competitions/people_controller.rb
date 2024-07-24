# frozen_string_literal: true

class Competitions::PeopleController < CompetitionNestedController
  default_resource

  def index
    send_pdf(Exports::Pdf::People, args: [@competition])
    send_xlsx(Exports::Xlsx::People, args: [@competition])
  end

  def create
    @person.assign_attributes(person_params)
    if @person.save
      CompetitionMailer.with(person: @person).registration_person.deliver_later if @person.applicant.present?

      if params[:return_to] == 'team'
        redirect_to competition_team_path(id: @person.team_id, anchor: 'people-table'), notice: :saved
      else
        redirect_to competition_person_path(id: @person.id), notice: :saved
      end
    else
      flash.now[:alert] = :check_errors
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    @person.assign_attributes(person_params)
    if @person.save
      if params[:return_to] == 'team'
        redirect_to competition_team_path(id: @person.team_id, anchor: 'people-table'), notice: :saved
      else
        redirect_to competition_person_path(id: @person.id), notice: :saved
      end
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

  def team_from_param
    @team_from_param ||= @competition.teams.find_by(id: params[:team])
  end

  def person_params
    params.require(:person).permit(
      :first_name, :last_name, :team_id, :band_id, :fire_sport_statistics_person_id, :registration_hint,
      :registration_order, :bib_number, :create_team_name,
      tags: [],
      requests_attributes: %i[assessment_type _destroy assessment_id id
                              group_competitor_order single_competitor_order
                              competitor_order]
    )
  end

  def assign_new_resource
    self.resource_instance = resource_class.new(competition: @competition)
    resource_instance.assign_attributes(team: team_from_param, band: team_from_param.band) if team_from_param.present?
    resource_instance.band ||= @competition.bands.find(params[:band_id])

    return if can?(:manage, @competition)
    return if can?(:edit, resource_instance.team)

    resource_instance.applicant = current_user
    resource_instance.registration_hint =
      "Mannschaftsleiter: #{current_user.name}\n" \
      "E-Mail-Adresse: #{current_user.email}\n" \
      "Telefonnummer: #{current_user.phone_number}\n"
  end
end
