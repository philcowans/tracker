class SatellitesController < ApplicationController
  def show
    satellite = Satellite.new(params[:id].to_i)

    @geo_coordinates = []

    0.upto 120 do |i|
      @geo_coordinates[i] = satellite.geo_coordinates(Time.now + i.minutes)
    end
  end
end
