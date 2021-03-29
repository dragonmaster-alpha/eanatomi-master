class FeaturedCategory < ApplicationRecord
  include Sortable
  include Activatable

  belongs_to :category

  def to_s
    category&.name || super
  end

end
