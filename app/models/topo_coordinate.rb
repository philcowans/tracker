class TopoCoordinate
  def initialize(coordinate)
    @coordinate = coordinate
  end

  def az
    @coordinate.az
  end

  def el
    @coordinate.el
  end

  def range
    @coordinate.range
  end
end
