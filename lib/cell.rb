class Cell
  attr_reader :coordinate, :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @cell_fired_upon = false
  end

  def empty?
    if @ship == nil
      return true
    else
      return false
    end
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    if !empty?
      @ship.hit
    end
    @cell_fired_upon = true
  end

  def fired_upon?
    @cell_fired_upon
  end

  def render(render_ship = false)
    if @ship && render_ship == true
      "S"
    elsif !empty? && @ship.sunk?
      "X"
    elsif fired_upon? && !empty?
      "H"
    elsif fired_upon?
      "M"
    else
      "."
    end
  end
end
