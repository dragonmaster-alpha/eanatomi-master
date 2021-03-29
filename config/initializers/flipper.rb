require 'flipper/middleware/memoizer'
Rails.configuration.middleware.use Flipper::Middleware::Memoizer

Flipper.configure do |config|
  config.default do
    Flipper.new Flipper::Adapters::Redis.new($redis)
  end
end

Flipper.register(:admins) do |actor|
  actor.respond_to?(:admin?) && actor.admin?
end
