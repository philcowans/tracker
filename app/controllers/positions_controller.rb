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
      
      format.kml do
        
        xml = Builder::XmlMarkup.new
        xml.kml( "xmlns" => "http://earth.google.com/kml/2.1", "hint" => "target=sky") do
          xml.Document {
            xml.name("Satellite Tracker")
            xml.description("Updated position of satellite with a given ID")
            xml.Style( "id" => "highlight" ) {
              xml.IconStyle {
                xml.Icon { xml.href("") }
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
                xml.name(p.id)
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
      render :xml => xml
      end
      
    end
  end
end
