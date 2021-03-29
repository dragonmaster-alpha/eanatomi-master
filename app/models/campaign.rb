class Campaign < ApplicationRecord
  include Activatable
  include ImgixUploader[:imgix_photo]

  PLACEMENTS = %w( home_full home_half header_left header_right )

  PLACEMENTS.each do |placement|
    scope "in_#{placement}", -> { where(placement: placement) }
  end

  def to_s
    name || super
  end

  def parameterize
    name.parameterize
  end

end
