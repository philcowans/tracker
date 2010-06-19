class PositionsController < ApplicationController
  def show
    satellite = Satellite.new(params[:satellite_id].to_i)
    timestamp_ref = TimestampRef.new(params[:id])

    geo_coordinates = satellite.geo_coordinates(timestamp_ref.timestamp)

    render :text => "Lat: #{geo_coordinates.lat}, Lon: #{geo_coordinates.lon}, Alt: #{geo_coordinates.alt}"
  end
end
