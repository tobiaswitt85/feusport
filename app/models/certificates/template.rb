# frozen_string_literal: true

class Certificates::Template < ApplicationRecord
  belongs_to :competition, touch: true
  has_many :text_fields, class_name: 'Certificates::TextField', inverse_of: :template, dependent: :destroy

  schema_validations
  validates :image, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..(10.megabytes) }
  validates :font, :font2,
            blob: { content_type: ['ttf', 'application/font-sfnt', 'font/ttf'], size_range: 1..(10.megabytes) }

  %i[image font font2].each do |file|
    has_one_attached file

    define_method(:"#{file}_path") do
      ActiveStorage::Blob.service.path_for(public_send(file).key) if public_send(file).attached?
    end
    define_method(:"#{file}_hint") do
      "Zur Zeit: #{public_send(file).filename}" if public_send(file).attached?
    end
  end

  accepts_nested_attributes_for :text_fields, allow_destroy: true

  def duplicate_to(new_competition)
    duplicate = dup
    duplicate.competition = new_competition
    duplicate.name = "#{duplicate.name} (Duplikat von »#{I18n.l(competition.date)} - #{competition.name}«)"
    duplicate.image.attach(image.blob) if image.attached?
    duplicate.font.attach(font.blob) if font.attached?
    duplicate.font2.attach(font2.blob) if font2.attached?

    text_fields.each do |text_field|
      duplicate.text_fields.build(text_field.attributes.except('id', 'created_at', 'updated_at'))
    end

    duplicate.save
    duplicate
  end
end
