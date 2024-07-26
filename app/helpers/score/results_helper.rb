# frozen_string_literal: true

module Score::ResultsHelper
  include Exports::ScoreResults

  def row_invalid_class(row)
    row.valid? ? '' : 'danger'
  end

  def calculation_method_options
    Score::Result::CALCULATION_METHODS
      .except(:zweikampf)
      .map { |k, _v| [t("score_calculation_methods.#{k}"), k] }
  end
end
