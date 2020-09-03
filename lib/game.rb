require "./lib/board"
require "./lib/ship"
require "./lib/cell"
require "./lib/computer"
require "./lib/player"

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
    @computer.computer_place_ship
    @player.player_place_ship(ship_hash)
    play_game
  end

  def generate_game
    board_size
    variable_ships
    @player_board = Board.new(@board_size)
    @computer = Computer.new(@board_size, @ship_hash)
    @player = Player.new(@board_size, @ship_hash)
    @winner = false
  end

  def play_game
    while @winner == false
      turn
    end
    if @player.player_lost? == true
      puts "I won"
    else
      puts "You won"
    end
    main_menu
  end

  def turn
    render_boards
    @player.player_shot(@computer.board)
    return nil if winner_validation? == true
    @computer.computer_shot(@player.board)
    return nil if winner_validation? == true
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
      @ship_hash.clear
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
    @ship_hash[name_of_ship] = length_of_ship
    puts "Would you like to create more ships? Enter y for yes and n for no"
    more_ships = gets.chomp.upcase
    if more_ships == "Y"
      variable_ships_helper
    end
  end

  def render_boards
    puts "=============COMPUTER BOARD============="
    puts @computer.board.render
    puts "==============PLAYER BOARD=============="
    puts @player.board.render(true)
  end

  def winner_validation?
    if @player.player_lost? || @computer.computer_lost?
      @winner = true
      return true
    end
  end
end
