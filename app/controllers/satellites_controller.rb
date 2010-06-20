class SatellitesController < ApplicationController
  def show
    satellite = Satellite.new(:id => params[:id].to_i)
    site = SxP4r::Site.new(56.0, 0.0, 0.0)

    @geo_coordinates = []
    @topo_coordinates = []

    0.upto 120 do |i|
      @geo_coordinates[i] = satellite.geo_coordinates(Time.now + i.minutes)
      @topo_coordinates[i] = satellite.topo_coordinates(site, Time.now + i.minutes)
    end
  end
end
