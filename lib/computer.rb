class Computer
  attr_reader :ship_array, :board_size
  attr_accessor :board
  def initialize(board_size, ship_hash)
    @board_size = board_size
    @board = Board.new(board_size)
    @ship_array = generate_ships(ship_hash)
  end

  def generate_ships(ship_hash)
    ship_collector = []
    ship_hash.each do |name, length|
      ship_collector << Ship.new(name, length)
    end
    ship_collector
  end

  def computer_place_ship
    @ship_array.each  do |ship|
      ship_coordinates = computer_ship_coordinates(ship)
      while @board.valid_placement?(ship, ship_coordinates) == false
        ship_coordinates = computer_ship_coordinates(ship)
      end
      @board.place(ship, ship_coordinates)
    end
  end

  def computer_shot(player_board)
    random_computer_shot = player_board.cells.keys.sample
    while player_board.board_fired_upon?(random_computer_shot)
      random_computer_shot = player_board.cells.keys.sample
    end
    player_board.board_fire_upon(random_computer_shot)
    turn_outcome_computer(random_computer_shot, player_board)
  end

  def turn_outcome_computer(random_computer_shot, player_board)
    if player_board.cells[random_computer_shot].empty?
      puts "My shot on #{random_computer_shot} was a miss"
    elsif player_board.cells[random_computer_shot].ship_sunk?
      puts "My shot hit and sunk a ship"
    else
      puts "My shot on #{random_computer_shot} was a hit"
    end
  end

  def computer_lost?
    total_ships = @ship_array.length
    sunken_ships = 0
    @ship_array.each do |ship|
      if ship.sunk?
        sunken_ships += 1
      end
    end
    if sunken_ships == total_ships
      true
    else
      false
    end
  end

  def computer_ship_coordinates(ship)
    randomizer = rand(2)
    if randomizer == 0
      horizontal_coordinate_array(ship)
    elsif randomizer == 1
      vertical_coordinate_array(ship)
    end
  end

  def horizontal_coordinate_array(ship)
    letter = ("A".."#{(65 + (@board_size - 1)).chr}").to_a.sample
    collector_for_each_cons = []
    horizontal_computer_placement = ("#{letter}1".."#{letter}#{@board_size}")
    horizontal_computer_placement.each_cons(ship.length){|consecutive_numbers| collector_for_each_cons << consecutive_numbers}
    return collector_for_each_cons[rand(collector_for_each_cons.length)]
  end

  def vertical_coordinate_array(ship)
    number = ("1".."#{@board_size}").to_a.sample
    collector_for_each_cons = []
    vertical_computer_placement = ("A".."#{(65 + (@board_size - 1)).chr}")
    vertical_computer_placement.each_cons(ship.length){|consecutive_letters| collector_for_each_cons << consecutive_letters}
    letter_coordinates = collector_for_each_cons[rand(collector_for_each_cons.length)]
    letter_coordinates.length.times do |counter|
      letter_coordinates[counter].insert(-1,number)
    end
    return letter_coordinates
  end
end
