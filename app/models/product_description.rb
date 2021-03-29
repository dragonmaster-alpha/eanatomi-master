class ProductDescription < ApplicationRecord
  include Sortable
  belongs_to :product
  has_many :translation_changes, dependent: :destroy, as: :object

  translates :body, accessors: I18n.available_locales
end
