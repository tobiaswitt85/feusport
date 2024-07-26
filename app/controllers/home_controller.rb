# frozen_string_literal: true

class HomeController < ApplicationController
  def home
    @years = Competition.accessible_by(current_ability)
                        .group(Arel.sql("DATE_PART('year', date)")).pluck(Arel.sql("DATE_PART('year', date)"))
                        .map(&:to_i).sort.reverse

    @competitions = Competition.accessible_by(current_ability)
    @competitions = if params[:year].blank?
                      @competitions.current
                    else
                      @competitions.where("DATE_PART('year', date) = ?", params[:year].to_i)
                    end
  end

  def info; end
  def help; end

  def disseminators
    @disseminators = Disseminator.reorder(:name)
  end
end
