# frozen_string_literal: true

Exports::Json::Score::CompetitionResults = Struct.new(:results) do
  include Exports::Json::Base
  include Exports::CompetitionResults

  def to_hash
    {
      results: results.map { |result| { name: result.name, rows: table_data(result) } },
    }
  end

  def filename
    'gesamtwertungen.json'
  end
end
