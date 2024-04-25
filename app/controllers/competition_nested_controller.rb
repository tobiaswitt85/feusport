# frozen_string_literal: true

class CompetitionNestedController < ApplicationController
  before_action :load_competition
  authorize_resource :competition

  def self.default_resource
    namespace = controller_path.split('/')[0..-2]
    name = controller_path.split('/').last.singularize
    load_and_authorize_resource(name.to_sym, through: :competition)
    namespaced_name = [namespace, name].join('/').singularize.camelize.safe_constantize || name

    define_method(:resource_class) do
      @resource_class ||= namespaced_name.to_s.camelize.constantize
    end
    helper_method :resource_class

    define_method(:resource_instance) do
      instance_variable_get(:"@#{name}")
    end
    helper_method :resource_instance

    define_method(:resource_collection) do
      instance_variable_get(:"@#{name.pluralize}")
    end
    helper_method :resource_collection
  end

  protected

  def load_competition
    @competition = Competition.find_by!(year: params[:year], slug: params[:slug])
  end
end
