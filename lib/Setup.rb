class Setup
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
    if user_input == p
      play_game
    end
  end
end
