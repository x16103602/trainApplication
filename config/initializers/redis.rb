$redis = Redis::Namespace.new("site_point", :redis => Redis.new(url: ENV["REDIS_URL"]))
if Rails.env == 'production'
  uri = URI.parse(ENV["REDIS_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end