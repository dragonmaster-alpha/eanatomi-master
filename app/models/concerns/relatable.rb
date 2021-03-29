module Relatable
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, class_name: 'Product'
    belongs_to :target, class_name: 'Product'

    default_scope -> { order(:position) }
  end

  class_methods do
  end

end
