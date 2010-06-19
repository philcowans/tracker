class GeoCoordinate
  def initialize(coordinate)
    @coordinate = coordinate
  end

  def lat
    @coordinate.lat * 180 / Math::PI
  end

  def lon
    lon_value = @coordinate.lon * 180 / Math::PI
    if lon_value <= 180
      lon_value
    else
      lon_value - 360
    end
  end

  def alt
    @coordinate.alt
  end
end
