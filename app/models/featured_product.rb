class FeaturedProduct < ApplicationRecord
  include Sortable
  include Activatable

  belongs_to :product

  def to_s
    product&.name || super
  end

end
