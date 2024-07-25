# frozen_string_literal: true

class HomeController < ApplicationController
  def home; end
  def info; end
  def help; end

  def disseminators
    @disseminators = Disseminator.reorder(:name)
  end
end
