class PositionsController < ApplicationController
  def index
    satellite = Satellite.new(:id => params[:satellite_id].to_i)

    base_time = Time.now
    interval = params[:interval].to_i
    length = params[:length].to_i

    geo_coordinates = []
    
    0.upto length do |i|
      geo_coordinates[i] = satellite.geo_coordinates(Time.now + i * interval.minutes)
    end

    respond_to do |format|
      format.json do
        json_response = {
          :positions => geo_coordinates.map do |c| {
            :satellite => satellite.name,
            :latitude => c.lat,
            :longitude => c.lon,
            :altitude => c.alt
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
      
      format.kml do
        
        xml = Builder::XmlMarkup.new(:indent => 2)
        output = xml.kml( "xmlns" => "http://earth.google.com/kml/2.1") do
          xml.Document {
            xml.name("Satellite Tracker")
            xml.description("Updated position of satellite with a given ID")
            xml.Style( "id" => "highlight" ) {
              xml.IconStyle {
                xml.Icon { xml.href("http://www.randomorbit.net/images/Satellite-icon.png") }
              }
              xml.BalloonStyle {
                xml.bgcolor('7fffffff')
                xml.text{
                  xml.cdata!("")
                }
              }
            }
           xml.Folder {
    	        xml.name(satellite.name)
    	        xml.Snippet("Snippet text")
    	        xml.visibility(1)
    	        xml.styleUrl("#highlight")
    	        xml.open(0)
    	        xml.description { xml.cdata!("More") }
    	        xml.LookAt {
                xml.longitude(geo_coordinates.lon)
                xml.latitude(geo_coordinates.lat)
                xml.altitude(geo_coordinates.alt)
                xml.range(100000)
                xml.heading(0)
              }

        	    xml.Placemark do
                xml.name(satellite.name)
                xml.visibility(0)
                xml.LookAt {
                  xml.longitude(geo_coordinates.lon)
                  xml.latitude(geo_coordinates.lat)
                  xml.altitude(geo_coordinates.alt)
                  xml.range(100000)
                  xml.heading(0)
                }
                xml.styleUrl("#highlight")
                xml.Point { xml.coordinates("#{geo_coordinates.lon},#{geo_coordinates.lat},#{geo_coordinates.alt}") }
              end
            }
          }
          end
      render :xml => output
      end
      
    end
  end
end
