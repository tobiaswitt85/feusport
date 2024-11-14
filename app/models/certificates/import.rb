# frozen_string_literal: true

class Certificates::Import
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :template_id, :competition, :selectable_templates, :duplicate

  validates :competition, :selectable_templates, :template, presence: true

  def template
    @template ||= selectable_templates&.find_by(id: template_id)
  end

  def save
    return unless valid?

    self.duplicate = template.duplicate_to(competition)
    duplicate.persisted?
  end
end
