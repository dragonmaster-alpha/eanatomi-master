class CategoryMegaimage < ApplicationRecord
  include Sortable
  include ImgixUploader[:imgix_photo]
  alias_method :img_url, :imgix_photo_url
  belongs_to :category

  MEGA_TYPES = %w( full half_height small)

  MEGA_TYPES.each do |mega_type|
    scope "in_#{mega_type}", -> { where(mega_type: mega_type) }
  end

  def parameterize
    category&.name.parameterize
  end

  def imgix_photo?
    imgix_photo
  end
end
