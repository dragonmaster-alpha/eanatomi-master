class ImportProductsJob < ApplicationJob
  queue_as :default

  def perform(storage)
    filename = storage.file.metadata["filename"]
    tmpfile = Tempfile.new encoding: 'ascii-8bit'
    tmpfile.write storage.file.read
    import = Import.new('ImportedProduct', tmpfile)
    import.update!

    storage.destroy!

    NotificationMailer.notify("#{filename} med #{import.item_size} produkter er blevet importeret").deliver_now
  end
end
