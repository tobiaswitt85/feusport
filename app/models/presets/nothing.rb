# frozen_string_literal: true

class Presets::Nothing < Presets::Base
  def name
    'Nichts vorgeben'
  end

  def params
    []
  end

  protected

  def perform; end
end
