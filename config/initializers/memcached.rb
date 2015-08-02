Health.services << Health::Service.new(
  :memcached,
  -> {
    begin
      Dalli::Client.new.version
      Rails.logger.info("[memcached] Healthy connection to memcached")
      true
    rescue Dalli::DalliError => e
      Rails.logger.warn("[memcached] Could not connect to memcached: #{e.message}")
      false
    end
  },
)
