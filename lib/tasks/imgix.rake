namespace :imgix do
  desc "migrates photos to imgix"
  task migrate: :environment do

    ProductPhoto.where(imgix_photo_data: nil).where.not(photo_data: nil).find_each do |product_photo|
      migrate_photo(product_photo)
    end

    Category.where(imgix_photo_data: nil).where.not(photo_data: nil).find_each do |category|
      migrate_photo(category)
    end

    Campaign.where(imgix_photo_data: nil).where.not(photo_data: nil).find_each do |campaign|
      migrate_photo(campaign)
    end

    TimelineEvent.where(imgix_photo_data: nil).where.not(photo_data: nil).find_each do |event|
      migrate_photo(event)
    end


  end

  private

  def migrate_photo(item)
    begin
      puts item.update imgix_photo: open(item.photo.url)
    rescue Exception => e
      puts e
    end
  end

end
