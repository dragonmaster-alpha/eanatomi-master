namespace :migrate_photo_store do
  desc "migrates product photo storage"
  task products: :environment do
    ProductPhoto.find_each do |product_photo|
      photo_data = JSON(product_photo.photo_data)
      photo_data['storage'] = 'photo_store'
      product_photo.photo_data = photo_data
      product_photo.save!
    end
  end
  desc "migrates category photo storage"
  task categories: :environment do
    Category.find_each do |category|
      if category.photo_data
        photo_data = JSON(category.photo_data)
        photo_data['storage'] = 'photo_store'
        category.photo_data = photo_data
        category.save!
      end
    end
  end

end
