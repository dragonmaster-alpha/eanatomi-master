class TranslationChange < ApplicationRecord
  belongs_to :user
  belongs_to :object, polymorphic: true

  scope :latest, -> { order(created_at: :desc).limit(10) }

  def self.track!(object, user, *fields)
    fields.map! { |f| "#{f}_translations" }

    object.changes.slice(*fields).each do |field, changes|
      was = changes[0] || {}
      is = changes[1] || {}
      locales = (was.keys + is.keys).uniq

      locales.each do |locale|
        if was[locale].presence != is[locale].presence
          TranslationChange.create(locale: locale, field: field.gsub('_translations', ''), changed_from: was[locale], changed_to: is[locale], object: object, user: user)
        end
      end
    end
  end
end
