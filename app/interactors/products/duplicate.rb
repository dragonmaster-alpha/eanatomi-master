class Products::Duplicate
  include Interactor

  def call
    context.duplicate = context.product.deep_clone(except: [:stock, :reference, :sku])
    context.duplicate.sku = sku


    if context.duplicate.valid?
      context.duplicate.save!
    else
      context.error = context.duplicate.errors.full_messages.join(', ')
      context.fail!
    end

    context.product.photos.each do |photo|
      ProductPhoto.create(imgix_photo: photo.imgix_photo, product: context.duplicate, position: photo.position)
    end

    context.product.additional_descriptions.sorted.each do |description|
      ProductDescription.create(product: context.duplicate, position: description.position, body_translations: description.body_translations)
    end
  end

  def sku
    context.sku || SecureRandom.hex(4)
  end
end
