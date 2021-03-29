namespace :reindex do
  desc "Reindexes queued items"
  task queue: :environment do
    Searchkick::ProcessQueueJob.perform_later(class_name: "Product")
    Searchkick::ProcessQueueJob.perform_later(class_name: "Order")
  end
end
