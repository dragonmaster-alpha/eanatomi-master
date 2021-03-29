class Notice < ApplicationRecord
  include Activatable
  translates :text, accessors: I18n.available_locales
end
