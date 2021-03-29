module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :create_slugs
  end

  class_methods do

    def slug(slug)
      result = find_by('slug_translations -> ? = ?', I18n.locale, slug.to_s) || find(slug)
      raise ActiveRecord::RecordNotFound if result.nil?
      result
    end

  end

  def to_param
    self.slug.blank? ? super : self.slug
  end

  def parameterize(locale)
    self.name_translations.to_h[locale].to_s.parameterize.downcase
  end

  def unique_slug?(locale)
    model_name.name.constantize.where.not(id: self.id).where('slug_translations -> ? = ?', locale, parameterize(locale)).empty?
  end

  def reset_slugs!
    self.slug_translations = {}
    create_slugs!
  end

  def create_slugs!
    self.create_slugs
    self.save!
  end

  def create_slugs
    Market.all.each do |market|
      create_slug(market.locale)
    end
  end

  def slug_with_postfix(locale)
    unique_slug?(locale) ? parameterize(locale) : "#{parameterize(locale)}-#{self.id}"
  end

  def create_slug(locale)
    self.slug_translations ||= {}
    self.slug_translations[locale] = slug_with_postfix(locale) if self.slug_translations[locale].blank?
  end

end
