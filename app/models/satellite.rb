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

  def topo_coordinates(site, timestamp)
    TopoCoordinate.new(site.get_look_angle(orbit.get_position(offset_from_epoch(timestamp))))
  end

  def visible(timestamp)
    eci = orbit.get_position(offset_from_epoch(timestamp))
    puts eci.x
    (eci.x < 0) and (eci.y**2.0 + eci.z**2.0 > 6378.1**2)
  end

  private

  def orbit
    SxP4r::Orbit.new(@tle)
  end

  def offset_from_epoch(timestamp)
    (((timestamp - Time.utc(timestamp.year)) / (24*60*60).to_f + 1) - @tle.get_fractional_day) * 60 * 24
  end
end
