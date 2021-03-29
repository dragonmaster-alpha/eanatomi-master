class TimelineEvent < ApplicationRecord
  include Sortable
  include ImgixUploader[:imgix_photo]
  translates :title, :body, accessors: I18n.available_locales

  SLIDER_TYPES = ['web_design', 'historical_events']
  SLIDER_TYPES.each do |slider_type|
    scope "in_#{}", -> { where(slider_type: slider_type) }
  end
  default_scope -> { order(:position) }

  def to_s
    title || super
  end

  def parameterize
    title.parameterize
  end

end
