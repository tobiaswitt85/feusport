# frozen_string_literal: true

class Firesport::Series::Handler
  def self.class_for(name, type)
    class_name = "Firesport::Series::#{type == :person ? 'Person' : 'Team'}::#{name}"
    begin
      "::#{class_name}".constantize
    rescue NameError => e
      return if e.message.start_with?("uninitialized constant #{class_name}")

      raise e
    end
  end

  def self.person_class_for(name)
    class_for(name, :person)
  end

  def self.team_class_for(name)
    class_for(name, :team)
  end
end
