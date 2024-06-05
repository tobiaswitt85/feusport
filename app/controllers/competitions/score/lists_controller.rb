# frozen_string_literal: true

class Competitions::Score::ListsController < CompetitionNestedController
  default_resource resource_class: Score::List, through_association: :score_lists

  def destroy_entity
    @entries = @list.entries.where(id: params[:entry_id])
  end

  def move
    return if params[:new_order].blank?

    order_params = params.require(:list).permit(:save, new_order: {})

    new_order = order_params[:new_order].to_h.values
    new_order.each_with_index do |entry_id, index|
      next if entry_id.nil?

      track = (index % @list.track_count) + 1
      run = (index / @list.track_count) + 1

      entry = @list.entries.find { |e| e.id == entry_id }
      entry.assign_attributes(track:, run:)
      entry.save if order_params[:save]
    end

    @list.errors.add(:base, :invalid) unless order_params[:save]
  end

  # before_action :assign_resource_for_action, only: %i[move select_entity destroy_entity edit_times]
  # before_action :assign_tags

  # def index
  #   @list_factory = Score::ListFactory.find_by(session_id: session.id.to_s)
  # end

  # def show
  #   super
  #   page_title @score_list.decorate.to_s
  #   send_pdf(Exports::PDF::Score::List) do
  #     [@score_list.decorate, params[:more_columns].present?, params[:double_run].present?]
  #   end
  #   send_xlsx(Exports::XLSX::Score::List) { [@score_list.decorate] }
  # end

  def edit_times
    authorize!(:edit_times, resource_instance)
  end

  def update
    @list.assign_attributes(list_params)
    if @list.save
      redirect_to competition_score_list_path, notice: :saved
    else
      flash.now[:alert] = :check_errors
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    redirect_to competition_score_lists_path, notice: :deleted
  end

  protected

  def list_params
    editable_attributes = %i[
      id run track entity_id entity_type _destroy assessment_type assessment_id
    ]

    editable_attributes.push(:result_type, :result_type_before) if can?(:edit_result_types, Score::ListEntry)
    if can?(:edit_times, Score::ListEntry)
      editable_attributes.push(:edit_second_time, :edit_second_time_before,
                               :edit_second_time_left_target, :edit_second_time_left_target_before,
                               :edit_second_time_right_target, :edit_second_time_right_target_before)
    end

    params.require(:score_list).permit(:name, :shortcut, :date, :show_multiple_assessments, :hidden,
                                       :show_best_of_run,
                                       result_ids: [],
                                       entries_attributes: editable_attributes)
  end
end
