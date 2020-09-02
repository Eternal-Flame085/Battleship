class Player
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

  def player_place_ship(ship_hash)
    puts `clear`
    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your #{ship_hash.length} ships."
    ship_string = ship_hash.map do |key, value|
      "The #{key} is #{value} units long"
    end
    puts ship_string
      @ship_array.each do |ship|
        puts @board.render(true)
        puts "Enter the squares for the #{ship.name} (#{ship.length} spaces)"
        player_input = gets.chomp.upcase.split(" ").to_a
          while @board.valid_placement?(ship, player_input) == false
            puts "Those are invalid coordinates. Please try again: (ex: A1 A2 A3)"
            player_input = gets.chomp.upcase.split(" ").to_a
          end
          @board.place(ship, player_input)
        end
  end

  def player_shot(computer_board)
    @valid = false
    puts "Enter the coordinate for your shot:"
    player_input = gets.chomp.upcase
    while @valid == false
      player_input = player_shot_validation(player_input, computer_board)
    end
    computer_board.board_fire_upon(player_input)
    puts turn_outcome_player(player_input, computer_board)
  end

  def player_shot_validation(player_input, computer_board)
    if computer_board.valid_coordinate?(player_input) == true
      if computer_board.board_fired_upon?(player_input) == true
        puts "Please select new coordinates: These coordinates have already been fired upon"
        player_input = gets.chomp.upcase
      else
        @valid = true
        player_input
      end
    elsif computer_board.valid_coordinate?(player_input) == false
      puts "Please enter a valid coordinate:"
      player_input = gets.chomp.upcase
    end
  end

  def turn_outcome_player(player_input, computer_board)
    if computer_board.cells[player_input].empty?
        return "Your shot on #{player_input} was a miss"
    elsif computer_board.cells[player_input].ship_sunk?
        return "Your shot hit and sunk a ship"
    else
        return "Your shot on #{player_input} was a hit"
    end
  end

  def player_lost?
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
end
