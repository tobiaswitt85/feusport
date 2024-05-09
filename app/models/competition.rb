# frozen_string_literal: true

class Competition < ApplicationRecord
  schema_validations

  belongs_to :user
  has_many :documents, dependent: :destroy
  has_many :disciplines, dependent: :destroy
  has_many :bands, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :people, dependent: :destroy
  has_many :score_lists, dependent: :destroy, class_name: 'Score::List'
  has_many :certificates_templates, dependent: :destroy, class_name: 'Certificates::Template'

  scope :visible, -> { where(visible: true) }
  scope :current, -> { visible.where(date: (5.days.ago..5.days.from_now)) }
  scope :upcoming, -> { visible.where(date: (Date.tomorrow..)) }
  scope :previous, -> { visible.where(date: (..Date.yesterday)) }

  before_validation(on: :create) do
    self.year = date&.year
    self.slug = name&.parameterize
    i = 0
    while Competition.exists?(year:, slug:)
      i += 1
      self.slug = "#{name.to_s.parameterize}-#{i}"
    end

    next if date.blank?

    self.description ||= "Der Wettkampf *#{name}* findet am **#{I18n.l date}** in **#{locality}** statt.\n\n" \
                         'Weitere Informationen folgen.'
  end

  def description_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(description)
  end

  def year_and_month
    @year_and_month ||= "#{date.year}-#{date.month}"
  end

  # def disciplines
  #   @disciplines ||= %w[hl hb la gs fs].shuffle.sample(5.times.to_a.sample)
  # end
end
