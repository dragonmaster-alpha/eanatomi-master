class ProductDecorator < Draper::Decorator
  delegate_all
  delegate :imgix_photo_url, to: :photo


  def meta_title
    object.meta_title.blank? ? object.name : object.meta_title
  end

  def photo?
    photos.any?
  end

  def poster?
    @_poster ||= /plakat/i === parents.last.name_da
  end

  def main_product
    if is_variant?
      object.product
    else
      object
    end
  end

  def photos
    object.photos.sorted
  end

  def variants
    if has_variants?
      active_variants.sorted.decorate(context: context)
    else
      [self]
    end
  end

  def has_variants?
    active_variants.any?
  end

  def active_variants
    @_active_variants ||= object.variants.active_in(context[:market].key)
  end

  def url
    h.product_url(object)
  end

  def has_addons?
    object.addons.active_in(context[:market].key).any?
  end

  def addons
    object.addons.active_in(context[:market].key).sorted.decorate(context: context)
  end

  def stock
    presumable_stock
  end

  def in_stock?
    stock > 0
  end

  def size?
    size.present?
  end

  def datasheet?
    datasheet
  end

  def video?
    video.present?
  end

  def video_id
    params = URI(video).query
    params = params.to_s.split('&')
    params.map! { |x| x.split('=') }
    params = params.to_h

    params['v']
  end

  def savings?
    sales_price.to_f < price.to_f
  end

  def savings
    price.to_f - sales_price.to_f
  end

  def savings_percentage
    (100 - sales_price.to_f / price.to_f * 100).to_i if savings?
  end

  def video_thumb
    "https://img.youtube.com/vi/#{video_id}/0.jpg"
  end

  def sales_price
    (vendor_price.sales_price || object.sales_price).to_f
  end

  def vendor_price
    @_vendor_price ||= VendorPrice.find_by(product: object, user: context[:user]) || VendorPrice.new
  end

  def purchasable?
    sales_price > 0
  end

  def shipping_time_description
    shipping_time.description
  end

end
