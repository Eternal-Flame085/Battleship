require "./lib/board"
require "./lib/ship"
require "./lib/cell"

class Game
  attr_reader :ship_hash, :computer_ship_array
  def initialize
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
    generate_game
    computer_place_ship(@computer_ship_array)
    player_place_ship(@player_ship_array)
    play_game
  end

  def generate_game
    board_size
    variable_ships
    @player_board = Board.new(@board_size)
    @computer_board = Board.new(@board_size)
    @computer_ship_array = generate_ships(@ship_hash)
    @player_ship_array = generate_ships(@ship_hash)
    @winner = false
  end

  def board_size
    @board_size = 4
    puts `clear`
    puts "Would you like to play on a cutom size board?"
    puts "Enter Y for yes, anything else and it defaults to a 4x4"
    yes_no = gets.chomp.upcase
    if yes_no == "Y"
      puts "Default board size is 4x4"
      puts "what board size do you want to play with?"
      puts "Ex: an input of 6 will generate a 6x6 board (Max:10)"
      @board_size = gets.chomp.to_i
      while @board_size > 10 || @board_size < 3 do
        puts "Board size cant be smaller than a 3x3 or bigger than a 10x10"
        @board_size = gets.chomp.to_i
      end
    end
  end

  def variable_ships
    @ship_hash = {"submarine" => 2, "cruiser" => 3}
    puts `clear`
    puts "Would you like to play with custom ships?"
    puts "Default ships are a submarine and cruiser"
    puts "Enter Y for yes, anything else and you will play with default ships"
    yes_no = gets.chomp.upcase

    if yes_no == "Y"
      variable_ships_helper
    end
  end

  def variable_ships_helper
    puts "What ships do you want to play with?"
    puts "Please enter the name of your ship"
    name_of_ship= gets.chomp
    puts "Please enter the length of your ship (Max: #{@board_size})"
    length_of_ship = gets.chomp.to_i
    while length_of_ship > @board_size do
      puts "Length of ship must be smaller than #{@board_size}"
      length_of_ship = gets.chomp.to_i
    end
    @ship_hash = {name_of_ship => length_of_ship}
    puts "Would you like to create more ships? Enter y for yes and n for no"
    more_ships = gets.chomp.upcase
    if more_ships == "Y"
      variable_ships_helper
    end
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
    render_boards
    player_shot
    return nil if winner_validation? == true
    computer_shot
    return nil if winner_validation? == true
  end

  def player_shot
    puts "Enter the coordinate for your shot:"
    player_input = gets.chomp.upcase
    while @computer_board.valid_coordinate?(player_input) == false || @computer_board.board_fired_upon?(player_input) == true
      player_input = player_shot_validation(player_input)
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

  def generate_ships(ship_hash)
    ship_collector = []
    @ship_hash.each do |name, length|
      ship_collector << Ship.new(name, length)
    end
    ship_collector
  end

  def player_place_ship(ship_array)
    puts `clear`
    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your #{@ship_hash.length} ships."
      ship_string = @ship_hash.map do |key, value|
      "The #{key} is #{value} units long"
    end
      puts ship_string
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

  def player_shot_validation(player_input)
    if @computer_board.board_fired_upon?(player_input) == true
      puts "Please select new coordinates: These coordinates have already been fired upon"
      player_input = gets.chomp.upcase
    elsif @computer_board.valid_coordinate?(player_input) == false
      puts "Please enter a valid coordinate:"
      player_input = gets.chomp.upcase
    end
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
