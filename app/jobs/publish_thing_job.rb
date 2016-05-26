class PublishThingJob < ApplicationJob
  queue_as :default

  def perform(thing)
    thing_json = JSON.dump(thing)

    Rails.logger.info { "[thing] Publishing #{thing_json}" }
    producer.produce(thing_json, topic: "things", partition_key: thing['id'])
    producer.deliver_messages
  end

  def kafka
    @kafka ||= Kafka.new(
      seed_brokers: Rails.configuration.kafka_hosts,
      logger: Rails.logger,
    )
  end

  def producer
    @producer ||= kafka.producer
  end
end
