Health.services << Health::Service.new(
  :elasticsearch,
  -> {
    begin
      Elasticsearch::Client.new.cluster.health
      Rails.logger.info("[elasticsearch] Healthy connection to elasticsearch")
      true
    rescue Faraday::Error => e
      Rails.logger.warn("[elasticsearch] Could not connect to Elasticsearch: [#{e.class.name}] #{e.message}")
      false
    end
  },
)
