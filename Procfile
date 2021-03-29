web: bin/qgsocksify bundle exec puma
worker: bin/qgsocksify bundle exec sidekiq -q mailers -q default -q searchkick
release: bundle exec rake db:migrate
