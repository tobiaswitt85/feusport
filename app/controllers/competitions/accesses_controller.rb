# frozen_string_literal: true

class Competitions::AccessesController < CompetitionNestedController
  default_resource resource_class: UserAccess, through_association: :user_accesses
end
