class ImgixUploader < Shrine

  plugin :keep_files, destroyed: true, replaced: true
  plugin :default_storage, store: :imgix_store
  plugin :default_url

  Attacher.default_url do |options|
    ''
  end

  def generate_location(io, context)
    return super if context[:phase] == :cache

    id = SecureRandom.hex(4)
    name = context[:record].parameterize
    ext = File.extname(context[:metadata]['filename'])
    ext = '.jpg' if ext.blank?

    "#{id}/#{name}#{ext}"
  end

end
