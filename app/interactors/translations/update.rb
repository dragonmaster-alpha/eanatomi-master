class Translations::Update
  include Interactor

  def call
    context.translations.each do |locale, translations|
      translations.each do |k, v|
        translation = Translation.find_or_initialize_by(locale: locale, key: k)
        translation.value = v

        if translation.value.blank?
          translation.destroy
        else
          translation.save!
        end
      end
    end
  end
end
