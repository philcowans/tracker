require "/home/ubuntu/SxP4r/sxp4r"

class Satellite
  attr_accessor :name

  def initialize(id)
    @id = id
    lines = TleSet.new.lookup_source(@id)
    @tle = SxP4r::TLE.new(lines[0], lines[1], lines[2])
    @name = lines[0].strip
  end

  def geo_coordinates(timestamp)
    GeoCoordinate.new(orbit.get_position(offset_from_epoch(timestamp)).to_geo)
  end

  private

  def orbit
    SxP4r::Orbit.new(@tle)
  end

  def offset_from_epoch(timestamp)
    (((timestamp - Time.utc(timestamp.year)) / (24*60*60).to_f + 1) - @tle.get_fractional_day) * 60 * 24
  end
end
