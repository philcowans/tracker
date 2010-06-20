class PassesController < ApplicationController
  def index
    satellite = Satellite.new(:id => params[:id].to_i)
    site = SxP4r::Site.new(params[:lat].to_f, params[:lon].to_f, params[:alt].to_f)

    @passes = []

    0.upto (60*24*60) do |i|
      coordinates = satellite.topo_coordinates(site, Time.now + i.seconds)
      if coordinates.el > 0.0 and satellite.visible(Time.now + i.seconds)
        geo_coordinates = satellite.geo_coordinates(Time.now + i.seconds)
        @passes << geo_coordinates
      end
    end
  end
end
