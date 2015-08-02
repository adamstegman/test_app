Health.services << Health::Service.new(
  :mysql,
  -> {
    ActiveRecord::Base.connection.active?
  },
)
