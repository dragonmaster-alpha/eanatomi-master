class Admin::TranslationChangesController < AdminController

  def index
    @locales = %w( da sv nb fi )
    @locale = params[:locale] || @locales.first

    @changes = TranslationChange.where(locale: @locale).order(created_at: :desc).page(params[:page]).per(100)
  end

  private

    def authorize
      authorize! :update, TranslationChange
    end
end
