class ListsController < ApplicationController
  def show
    timestamp_ref = TimestampRef.new(params[:id])

    geo_coordinates = []

    TleSet.new(params[:set_id]).each_source do |lines|
      satellite = Satellite.new(:lines => lines)
      geo_coordinates << [satellite.name, satellite.geo_coordinates(timestamp_ref.timestamp)]
    end
    
    respond_to do |format|
      format.json do
        json_response = {
          :positions => geo_coordinates.map do |c| {
            :satellite => c[0],
            :latitude => c[1].lat,
            :longitude => c[1].lon,
            :altitude => c[1].alt
            }
          end
        }.to_json
        if params[:callback]
          render :json => "#{params[:callback]}(#{json_response})"
        else
          render :json => json_response
        end
      end
    end
  end
end
