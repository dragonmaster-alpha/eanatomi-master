Searchkick.redis = ConnectionPool.new { Redis.new(url: ENV['REDIS_URL']) }
Searchkick.timeout = 1
Searchkick.search_timeout = 1
