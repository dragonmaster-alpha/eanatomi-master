class ProductPhoto < ApplicationRecord
  include Sortable
  include ImgixUploader[:imgix_photo]
  alias_method :url, :imgix_photo_url


  belongs_to :product, optional: true, touch: true

  def parameterize
    product&.name.parameterize
  end

  def imgix_photo?
    imgix_photo
  end

end
