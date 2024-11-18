# frozen_string_literal: true

class WkoController < ApplicationController
  def show
    @wko = Wko.find_by!(slug: params[:id])
  end
end
