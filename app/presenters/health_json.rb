class HealthJson
  def initialize(health)
    @health = health
  end

  def to_json(_)
    {
      healthy: @health.healthy?,
      services: @health.services.reduce({}) { |a, s| a.merge(s.name => s.healthy?) },
    }.to_json
  end
end
