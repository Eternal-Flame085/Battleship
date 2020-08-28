class Board
  attr_reader :cells
  def initialize
    @cells = Hash.new

    ("A".."D").each do |letter|
      (1..4).each do |number|
        @cells["#{letter + number.to_s}"] = Cell.new("#{letter + number.to_s}")
      end
    end
  end

  def valid_coordinate?(cell)
    @cells.has_key?(cell)
  end

  def  valid_coordinates(coordinates)
    coordinates.each do |coord|
      return false if valid_coordinate?(coord) == false
    end
  end

  def valid_placement?(ship, coordinates)
    return false if valid_coordinates(coordinates) == false
    return false if ship.length != coordinates.length
    return false if overlaping_ship?(coordinates) == false
    horizontal_and_vertical_validation?(coordinates[0], coordinates[-1], ship)
  end

  def overlaping_ship?(coordinates)
    coordinates.each do |coord|
      return false if @cells[coord].empty? != true
    end
  end

  def place(ship, coordinates)
    coordinates.each do |coord|
      @cells[coord].place_ship(ship)
    end
  end

  def horizontal_and_vertical_validation?(coord1, coord2, ship)
    valid_coords = []
    if coord1[0] == coord2[0]
      horizontal_placement = ("1".."4")
      coordinate_array = (coord1[1]..coord2[1]).to_a
      horizontal_placement.each_cons(ship.length) {|consecutive_numbers| valid_coords << consecutive_numbers}
    elsif coord1[1] == coord2[1]
      vertical_placement = ("A".."D")
      coordinate_array = (coord1[0]..coord2[0]).to_a
      vertical_placement.each_cons(ship.length) {|consecutive_letters| valid_coords << consecutive_letters}
    end
    valid_coords.include? coordinate_array
  end

  # def horizontal_validation?(coord1, coord2, ship)
  #   valid_coords = []
  #   if coord1[0] == coord2[0]
  #     horizontal_placement = ["1".."4"]
  #     coordinate_array = (coord1[1]..coord2[1]).to_a
  #     horizontal_placement.each_cons(ship.length) {|consecutive_numbers| valid_coords << consecutive_numbers}
  #   end
  #   valid_coords.include? coordinate_array
  # end
  #
  # def vertical_validation?(coord1, coord2, ship)
  #   valid_coords = []
  #   if coord1[1] == coord2[1]
  #     vertical_placement = ["A".."D"]
  #     coordinate_array = (coord1[0]..coord2[0]).to_a
  #     vertical_placement.each_cons(ship.length) {|consecutive_letters| valid_coords << consecutive_letters}
  #   end
  #   valid_coords.include? coordinate_array
  # end
end
