# frozen_string_literal: true

class CompetitionNestedController < ApplicationController
  before_action :load_competition
  authorize_resource :competition

  protected

  def load_competition
    @competition = Competition.find_by!(year: params[:year], slug: params[:slug])
  end
end
