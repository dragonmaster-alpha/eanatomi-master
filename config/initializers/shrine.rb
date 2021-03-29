require 'shrine/storage/file_system'
require 'shrine/storage/imgix'
require 'shrine/storage/s3'

Shrine.plugin :activerecord

Shrine.storages[:cache] = Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache')

Shrine.storages[:store] = Shrine::Storage::S3.new(
  upload_options: { acl: 'public-read' },
  access_key_id: ENV['BUCKETEER_AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'],
  region: 'eu-west-1',
  bucket: ENV['BUCKETEER_BUCKET_NAME'] || "bucketeer-f55a4920-fded-407f-8399-df4cce58728e"
)

if ENV['IMGIX_HOST']
  Shrine.storages[:imgix_store] = Shrine::Storage::Imgix.new(
    storage:          Shrine.storages[:store],
    api_key:          ENV['IMGIX_API_KEY'],
    host:             ENV['IMGIX_HOST']
  )
end
