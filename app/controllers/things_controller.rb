class ThingsController < ApplicationController
  # GET /things/new
  def new
    @thing = Thing.new
  end

  # GET /things/1/edit
  def edit
    @thing = Thing.new(id: params[:id])
  end

  # PUT /things
  # PUT /things.json
  def update
    @thing = Thing.new(id: params[:id], name: params[:name])
    PublishThingJob.perform_later(@thing.as_json)
    redirect_to edit_thing_path(id: @thing.id)
  end

  # DELETE /things/1
  # DELETE /things/1.json
  def destroy
    # FIXME: tombstone
    render text: '¯\_(ツ)_/¯', status: 500
  end
end
