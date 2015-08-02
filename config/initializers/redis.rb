Health.services << Health::Service.new(
  :redis,
  -> {
    begin
      Redis.new.ping
      Rails.logger.info("[redis] Healthy connection to redis")
      true
    rescue Redis::BaseError => e
      Rails.logger.warn("[redis] Could not connect to Redis: #{e.message}")
      false
    end
  },
)
