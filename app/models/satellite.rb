require "/home/ubuntu/SxP4r/sxp4r"

class Satellite
  def initialize(id)
    @id = id
  end

  def geo_coordinates(timestamp)
    orbit.get_position(offset_from_epoch(timestamp)).to_geo
  end

  private

  def tle
    return @tle if @tle

    line1 = 'ISS (ZARYA)'
    line2 = '1 25544U 98067A   10170.35950978  .00009622  00000-0  76728-4 0  3497'
    line3 = '2 25544  51.6460 219.4899 0009133 342.2288 127.9785 15.71907726663819'
    
    @tle = SxP4r::TLE.new(line1, line2, line3)
  end

  def orbit
    SxP4r::Orbit.new(tle)
  end

  def offset_from_epoch(timestamp)
    (((timestamp - Time.utc(timestamp.year)) / (24*60*60).to_f + 1) - tle.get_fractional_day) * 60 * 24
  end
end
