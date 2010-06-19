class PositionsController < ApplicationController
  def show
    satellite = Satellite.new(params[:satellite_id].to_i)
    timestamp_ref = TimestampRef.new(params[:id])

    geo_coordinates = satellite.geo_coordinates(timestamp_ref.timestamp)

    respond_to do |format|
      format.json do
        render :json => {
          :position => {
            :satellite => satellite.name,
            :timestamp => timestamp_ref.timestamp,
            :latitude => geo_coordinates.lat,
            :longitude => geo_coordinates.lon,
            :altitude => geo_coordinates.alt
          }
        }.to_json
      end

      format.xml do
        builder = Builder::XmlMarkup.new
        xml = builder.position(:satellite => satellite.name) do |p|
          p.timestamp timestamp_ref.timestamp
          p.latitude geo_coordinates.lat
          p.longitude geo_coordinates.lon
          p.altitude geo_coordinates.alt
        end
        render :xml => xml
      end
    end
  end
end
