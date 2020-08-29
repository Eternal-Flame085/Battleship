require "./lib/board"
require "./lib/ship"
require "./lib/cell"

class Game
  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @ship_hash = {2 => "submarine", 3 => "cruiser"}
    main_menu
  end

  def game_setup
    computer_ship_array = generate_ships(@ship_hash)
    player_ship_array = generate_ships(@ship_hash)
    computer_place_ship(computer_ship_array)
    player_place_ship(player_ship_array)
    puts @computer_board.render(true)
  end

  def generate_ships(ship_hash)
    ship_collector = []
    @ship_hash.each do |length, name|
      ship_collector << Ship.new(name, length)
    end
    ship_collector
  end

  def player_place_ship(ship_array)

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
      puts "I am here"
    end
    puts "I am out here"
  end

  def play_game
    computer_ship_placement
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
