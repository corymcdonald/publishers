if Rails.application.secrets[:redis_url].present?
  ActiveJob::TrafficControl.client = ConnectionPool.new(size: 5, timeout: 5) { Redis.new }
end
