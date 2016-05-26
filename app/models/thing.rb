class Thing
  attr_reader :id, :name

  def initialize(id: nil, name: "")
    @id = id || SecureRandom.uuid
    @name = name
  end

  def as_json
    {
      'id' => id,
      'name' => name,
    }
  end
end
