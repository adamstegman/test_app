class HealthController < ApplicationController
  def show
    respond_to do |format|
      format.html do
        @health = Health
      end
      format.json do
        status = Health.healthy? ? 200 : 503
        render json: HealthJson.new(Health), status: status
      end
    end
  end
end
