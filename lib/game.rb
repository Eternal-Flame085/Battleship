require "./lib/board"
require "./lib/ship"
require "./lib/cell"

class Game
  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @ship_hash = {2 => "submarine", 3 => "cruiser"}
    @computer_ship_array = generate_ships(@ship_hash)
    @player_ship_array = generate_ships(@ship_hash)
    @winner = false
    main_menu
  end

  def main_menu
    user_input = ""
    puts "Welcome to BATTLESHIP"
    loop do
      puts "Enter p to play. Enter q to quit."
      user_input = gets.chomp.downcase
      break if user_input == "p" || user_input == "q"
    end
    exit if user_input == "q"
    if user_input == "p"
      game_setup
    end
  end

  def game_setup
    computer_place_ship(@computer_ship_array)
    player_place_ship(@player_ship_array)
    play_game
  end

  def play_game
    while @winner == false
      turn
    end
    if player_lost? == true
      puts "I won"
    else
      puts "You won"
    end
    main_menu
  end

  def turn
    puts `clear`
    render_boards
    player_shot
    return nil if winner_validation? == true
    computer_shot
    return nil if winner_validation? == true
  end

  def generate_ships(ship_hash)
    ship_collector = []
    @ship_hash.each do |length, name|
      ship_collector << Ship.new(name, length)
    end
    ship_collector
  end

  def player_place_ship(ship_array)
    puts `clear`
    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."
    ship_array.each do |ship|
      puts @player_board.render(true)
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces)"
      player_input = gets.chomp.upcase.split(" ").to_a
      while @player_board.valid_placement?(ship, player_input) == false
        puts "Those are invalid coordinates. Please try again: (ex: A1 A2 A3)"
        player_input = gets.chomp.upcase.split(" ").to_a
      end
      @player_board.place(ship, player_input)
    end
  end

  def computer_place_ship(ship_array)
    ship_array.each  do |ship|
      ship_coordinates = computer_ship_coordinates(ship)
      while @computer_board.valid_placement?(ship, ship_coordinates) == false
        ship_coordinates = computer_ship_coordinates(ship)
      end
      @computer_board.place(ship, ship_coordinates)
    end
  end

  def render_boards
    puts "=============COMPUTER BOARD============="
    puts @computer_board.render
    puts "==============PLAYER BOARD=============="
    puts @player_board.render(true)
  end

  def winner_validation?
    if player_lost? == true || computer_lost? == true
      @winner = true
      return true
    end
  end

  def player_shot
    puts "Enter the coordinate for your shot:"
    player_input = gets.chomp.upcase
    while @computer_board.valid_coordinate?(player_input) == false
      puts "Please enter a valid coordinate:"
      player_input = gets.chomp.upcase
      if @computer_board.board_fired_upon?(player_input) == true
        puts "Please select new coordinates: These coordinates have already been fired upon"
        player_input = gets.chomp.upcase
      end
    end
    @computer_board.board_fire_upon(player_input)
    turn_outcome_player(player_input)
  end

  def computer_shot
    random_computer_shot = @player_board.cells.keys.sample
    while @player_board.board_fired_upon?(random_computer_shot)
      random_computer_shot = @player_board.cells.keys.sample
    end
    @player_board.board_fire_upon(random_computer_shot)
    turn_outcome_computer(random_computer_shot)
  end

  def turn_outcome_player(player_input)
    if @computer_board.cells[player_input].empty?
        puts "Your shot on #{player_input} was a miss"
    elsif @computer_board.cells[player_input].ship_sunk?
        puts "Your shot hit and sunk a ship"
    else
        puts "Your shot on #{player_input} was a hit"
    end
  end

  def turn_outcome_computer(random_computer_shot)
    if @player_board.cells[random_computer_shot].empty?
      puts "My shot on #{random_computer_shot} was a miss"
    elsif @player_board.cells[random_computer_shot].ship_sunk?
      puts "My shot hit and sunk a ship"
    else
      puts "My shot on #{random_computer_shot} was a hit"
    end
  end

  def player_lost?
    total_ships = @player_ship_array.length
    sunken_ships = 0
    @player_ship_array.each do |ship|
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

  def computer_lost?
    total_ships = @computer_ship_array.length
    sunken_ships = 0
    @computer_ship_array.each do |ship|
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
      horiztonal_coordinate_array(ship)
    elsif randomizer == 1
      vertical_coordinate_array(ship)
    end
  end

  def horiztonal_coordinate_array(ship)
    letter = ("A".."D").to_a.sample
    collector_for_each_cons = []
    horizontal_computer_placement = ("#{letter}1".."#{letter}4")
    horizontal_computer_placement.each_cons(ship.length){|consecutive_numbers| collector_for_each_cons << consecutive_numbers}
    return collector_for_each_cons[rand(collector_for_each_cons.length)]
  end

  def vertical_coordinate_array(ship)
    number = ("1".."4").to_a.sample
    collector_for_each_cons = []
    vertical_computer_placement = ("A".."D")
    vertical_computer_placement.each_cons(ship.length){|consecutive_letters| collector_for_each_cons << consecutive_letters}
    letter_coordinates = collector_for_each_cons[rand(collector_for_each_cons.length)]
    letter_coordinates.length.times do |counter|
      letter_coordinates[counter].insert(-1,number)
    end
    return letter_coordinates
  end
end
