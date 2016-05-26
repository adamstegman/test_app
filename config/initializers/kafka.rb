require "kafka"

Rails.configuration.kafka_hosts = ENV.fetch("KAFKA_URL") { Rails.logger.warn("KAFKA_URL is not set") }.split(",")
