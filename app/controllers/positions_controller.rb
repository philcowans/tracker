class PositionsController < ApplicationController
  def index
    satellite = Satellite.new(params[:satellite_id].to_i)

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
      
      format.kml do
        
        linestring = geo_coordinates.map do |c|
          "#{geo_coordinates.lat},#{geo_coordinates.lon},#{geo_coordinates.alt}"
        end.join("\n")
        
        xml = Builder::XmlMarkup.new(:indent => 2)
        output = xml.kml( "xmlns" => "http://earth.google.com/kml/2.1") do
          xml.Document {
            xml.name("Satellite Tracker")
            xml.description("Updated position of satellite with a given ID")
            xml.Style( "id" => "highlight" ) {
              xml.IconStyle {
                xml.scale(1.5)  
                xml.Icon {
                  xml.href("http://www.randomorbit.net/images/Satellite-icon.png")
                }
              }
              xml.BalloonStyle {
                xml.bgcolor('7fffffff')
                xml.text{
                  xml.cdata!("Tracking $[name]<br/>Current altitude is #{geo_coordinates.alt} km.")
                }
              }
            }
           xml.Folder {
    	        xml.name(satellite.name)
    	        xml.Snippet("Tracking $[name] in orbit.")
    	        xml.visibility(1)
    	        xml.styleUrl("#highlight")
    	        xml.open(0)
    	        xml.description { xml.cdata!("Tracking $[name] in orbit.") }
    	        xml.LookAt {
                xml.longitude(geo_coordinates[0].lon)
                xml.latitude(geo_coordinates[0].lat)
                xml.altitude(geo_coordinates[0].alt)
                xml.range(100000)
                xml.heading(0)
              }

        	    xml.Placemark do
                xml.name(satellite.name)
                xml.visibility(1)
                xml.LookAt {
                  xml.longitude(geo_coordinates[0].lon)
                  xml.latitude(geo_coordinates[0].lat)
                  xml.altitude(geo_coordinates[0].alt)
                  xml.range(100000)
                  xml.heading(0)
                }
                xml.styleUrl("#highlight")
                xml.Point { xml.coordinates("#{geo_coordinates.lon},#{geo_coordinates.lat},#{geo_coordinates.alt}") }
                xml.extrude(1)
              end
              
              xml.Placemark do
                xml.Style( "id" => "LineStyle" ) {
                  xml.LineStyle {  
                    xml.color('88BBFFBB')
                    xml.width(2)
                  }
                }
                xml.name('Projected Orbit')
                xml.styleUrl('#LineStyle')
                xml.Polygon {
                  xml.LineString {
                    xml.tessellate(1)
                    xml.altitudeMode('relativeToGround')
                    xml.coordinates(linestring)
                  }
                }
              end
            }
          }
          end
      render :xml => output
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
                xml.scale(1.5)  
                xml.Icon {
                  xml.href("http://www.randomorbit.net/images/Satellite-icon.png")
                }
              }
              xml.BalloonStyle {
                xml.bgcolor('7fffffff')
                xml.text{
                  xml.cdata!("Tracking $[name]<br/>Current altitude is #{geo_coordinates.alt} km.")
                }
              }
            }
           xml.Folder {
    	        xml.name(satellite.name)
    	        xml.Snippet("Tracking $[name] in orbit.")
    	        xml.visibility(1)
    	        xml.styleUrl("#highlight")
    	        xml.open(0)
    	        xml.description { xml.cdata!("Tracking $[name] in orbit.") }
    	        xml.LookAt {
                xml.longitude(geo_coordinates.lon)
                xml.latitude(geo_coordinates.lat)
                xml.altitude(geo_coordinates.alt)
                xml.range(100000)
                xml.heading(0)
              }

        	    xml.Placemark do
                xml.name(satellite.name)
                xml.visibility(1)
                xml.LookAt {
                  xml.longitude(geo_coordinates.lon)
                  xml.latitude(geo_coordinates.lat)
                  xml.altitude(geo_coordinates.alt)
                  xml.range(100000)
                  xml.heading(0)
                }
                xml.styleUrl("#highlight")
                xml.Point { xml.coordinates("#{geo_coordinates.lon},#{geo_coordinates.lat},#{geo_coordinates.alt}") }
                xml.extrude(1)
              end
            }
          }
          end
      render :xml => output
      end
      
    end
  end
end
