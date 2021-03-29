class CategoryBanner < ApplicationRecord
  include Sortable
  include ImgixUploader[:imgix_photo]
  alias_method :url, :imgix_photo_url
  belongs_to :category

  def parameterize
    category&.name.parameterize
  end

  def imgix_photo?
    imgix_photo
  end
end
