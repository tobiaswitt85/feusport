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

  def self.team_class_names
    Firesport::Series::Team::Base.descendants.map { |k| k.name.demodulize }
  end

  def self.person_class_names
    Firesport::Series::Person::Base.descendants.map { |k| k.name.demodulize }
  end

  def self.class_names
    (team_class_names + person_class_names).uniq.sort
  end
end
