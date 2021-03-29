namespace :import do

  desc "Import all the things"
  task all: :environment do
    import_categories
    import_products
  end


  desc "Import categories from csv"
  task categories: :environment do
    import_categories
  end

  desc "Import products from csv"
  task products: :environment do
    import_products
  end

  desc "Import urls"
  task urls: :environment do
    Importer.new('products').items('PRODUCTS PRODUCT').each do |item|
      url = LegacyUrl.find_or_initialize_by(kind: 'product', reference: item.field('NUMBER'))
      url.path = item.field('URL')
      url.save!
    end

    Importer.new('categories').items('CATEGORIES CATEGORY').each do |item|
      url = LegacyUrl.find_or_initialize_by(kind: 'category', reference: item.field('CATEGORY_ID'))
      url.path = item.field('URL')
      url.save!
    end
  end

  desc "Import product references"
  task product_references: :environment do
    Importer.new('products').items('PRODUCTS PRODUCT').each do |item|
      if product = Product.sku(item.field('NUMBER'))
        product.reference = item.field('PRODUCT_ID')
        product.save
      end
    end
  end

  private

    def import_categories

      items = Importer.new('categories').items('CATEGORIES CATEGORY')

      items.each do |item|
        category = Category.find_or_initialize_by(reference: item.field('CATEGORY_ID'))

        category.name_da  = item.field('TITLE_DK')
        category.name_sv  = item.field('TITLE_SE')
        category.name_nb  = item.field('TITLE_NO2')

        category.meta_description_da = item.field('DESCRIPTION_BOTTOM_DK')
        category.meta_description_sv = item.field('DESCRIPTION_BOTTOM_SE')
        category.meta_description_nb = item.field('DESCRIPTION_BOTTOM_NO2')

        category.status   = { '0' => :inactive, '1' => :active }.fetch(item.field('STATUS'))

        if category.new_record?
          category.position = item.field('SORTING')
        end

        unless category.photo?
          uri = URI("http://www.eanatomi.dk#{item.field('URL')}")
          doc = Oga.parse_html(Net::HTTP.get(uri))
          photo = open_file(read_og('image', doc))
          category.photo = photo
        end

        category.save!

      end

      items.each do |item|
        category = Category.find_by(reference: item.field('CATEGORY_ID'))
        category.update category: Category.find_by(reference: item.field('PARENT_ID'))
      end
    end

    def import_products
      Importer.new('products').items('PRODUCTS PRODUCT').each do |item|

        product = Product.find_or_initialize_by(sku: item.field('NUMBER'))

        product.reference           = item.field('PRODUCT_ID')
        product.name_da             = item.field('TITLE_DK')
        product.name_sv             = item.field('TITLE_SE')
        product.name_nb             = item.field('TITLE_NO2')
        product.description_da      = item.field('DESCRIPTION_SHORT_DK')
        product.description_sv      = item.field('DESCRIPTION_SHORT_SE')
        product.description_nb      = item.field('DESCRIPTION_SHORT_NO2')
        product.meta_title_da       = item.field('SEO_TITLE_DK')
        product.meta_title_sv       = item.field('SEO_TITLE_SE')
        product.meta_title_nb       = item.field('SEO_TITLE_NO2')
        product.meta_description_da = item.field('SEO_DESCRIPTION_DK')
        product.meta_description_sv = item.field('SEO_DESCRIPTION_SE')
        product.meta_description_nb = item.field('SEO_DESCRIPTION_NO2')
        product.keywords_da         = item.field('SEO_KEYWORDS_DK')
        product.keywords_sv         = item.field('SEO_KEYWORDS_SE')
        product.keywords_nb         = item.field('SEO_KEYWORDS_NO2')
        product.price               = item.field('PRICE')
        product.cost_price          = item.field('BUY_PRICE')
        product.offer_price         = product.price - BigDecimal(item.field('DISCOUNT')) unless item.field('DISCOUNT') == '0,00'
        product.status              = { '0' => :inactive, '1' => :active }.fetch(item.field('STATUS'))
        product.manufacturer        = Manufacturer.find_or_create_by(reference: item.field('MANUFACTURER_ID')) if item.field('MANUFACTURER_ID').present?
        product.shipping_time       = ShippingTime.find_or_create_by(reference: item.field('DELIVERY_ID')) if item.field('DELIVERY_ID').present?
        product.datasheet         ||= open_file(item.field('PDF_FILES'), prefix: 'http://www.eanatomi.dk/upload_dir/shop/')

        if product.new_record?
          product.category = Category.find_by(reference: item.field('CATEGORY_ID'))
          product.position = item.field('SORTING')
          product = Products::Create.call(product: product).product
        else
          product.save!
        end

        unless product.photo?
          item.field('PICTURES').split('|').each do |filename|
            photo = open_file(filename, prefix: 'http://www.eanatomi.dk/upload_dir/shop/')
            ProductPhoto.create!(photo: photo, product: product)
          end
        end

      end
    end

    def open_file(path, prefix: nil)
      begin
        open("#{prefix}#{path}") if path.present?
      rescue OpenURI::HTTPError
        nil
      end
    end

    def read_og(key, doc)
      doc.css("meta[property='og:#{key}']").first&.attributes&.last&.value&.encode
    end

end
