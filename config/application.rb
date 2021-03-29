require File.expand_path('../boot', __FILE__)

require 'rails/all'
require './lib/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eanatomi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    config.i18n.default_locale = :da

    config.i18n.fallbacks = [:da]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)

    config.middleware.insert 0, Rack::Rewrite do
      r301 '/product_feeds.xml', '/feeds/google_shopping.xml'
      r301 /(.+)\$/, '/$1'
      r301 '/p/detaljeret-skeletmodel-fra-altay-scientific-1996', '/p/detaljeret-skeletmodel-i-voksen-storrelse-2000'

      r301 '/somso-modelle-og-andre-fabrikanter-8', 'https://blog.eanatomi.dk/2018/06/eanatomis-leverandrer-og-fabrikanter.html'
      r301 '/guide-til-anatomiske-plakater-10', 'https://blog.eanatomi.dk/2018/06/guide-til-anatomiske-plakater.html'
      r301 '/the-brand-new-muscular-system-poster-from-eanatomi-16', 'https://blog.eanatomi.dk/2018/06/introducing-our-brand-new-anatomy-poster.html'
    end

    def warehouse
      ENV['WAREHOUSE']
    end

  end
end
