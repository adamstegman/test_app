module Health
  def self.healthy?
    @services.all?(&:healthy?)
  end

  def self.services
    @services ||= []
  end

  Service = Struct.new(:name, :health_check) do
    def healthy?
      health_check.call
    end
  end
end
