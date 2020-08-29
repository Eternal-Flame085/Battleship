class Setup
  def initialize

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
    if user_input == p
      play_game
    end
  end

  def play_game
    computer_ship_placement
    require "pry";binding.pry
  end

  def computer_ship_placement(ship = 3)
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
    horizontal_computer_placement.each_cons(ship){|consecutive_numbers| collector_for_each_cons << consecutive_numbers}
    return collector_for_each_cons[rand(collector_for_each_cons.length)]
  end
#ship should be ship.length when finalized and default value should just be ship
  def vertical_coordinate_array
    number = ("1".."4").to_a.sample
    collector_for_each_cons = []
    vertical_computer_placement = ("A".."D")
    vertical_computer_placement.each_cons(ship){|consecutive_letters| collector_for_each_cons << consecutive_letters}
    letter_coordinates = collector_for_each_cons[rand(collector_for_each_cons.length)]

    letter_coordinates.length.times do |counter|
      letter_coordinates[counter].insert(-1,number)
    end
    return letter_coordinates
  end
end
