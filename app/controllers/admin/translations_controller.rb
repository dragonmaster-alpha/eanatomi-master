class Admin::TranslationsController < AdminController

  def show
    @current_locale = params[:locale] || ENV['DEFAULT_LOCALE']
    @scopes = Translations::Load.call(locale: 'da').scopes
    @locales = Market.all.map { |m| [m.locale, m.country] }.uniq.to_h
  end

  def update
    if params[:translations]
      update_all(params[:translations])
      redirect_to [:admin, :translations], notice: 'Ændringerne blev gemt'
    elsif params[:translation]
      patch(params[:translation][:locale], params[:translation][:key], params[:translation][:value])
      head :ok
    end
  end


  private

    def update_all(translations)
      Translations::Update.call(translations: translations)
      I18n.reload!
    end

    def patch(locale, key, value)
      translation = Translation.find_or_initialize_by(locale: locale, key: key)
      translation.value = value

      if translation.value.blank?
        translation.destroy
      else
        translation.save!
      end
      I18n.reload!
    end

    def authorize
      authorize! :update, Translation
    end

end
