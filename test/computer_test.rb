require "minitest/autorun"
require "minitest/pride"
require "./lib/board"
require "./lib/ship"
require "./lib/cell"
require "./lib/computer"
require "./lib/player"
require "mocha/minitest"

class ComputerTest < Minitest::Test
  def setup
    @ship_hash = {"submarine" => 2, "cruiser" => 3}
    @computer = Computer.new(4, @ship_hash)
  end

  def test_it_exists
    assert_instance_of Computer, @computer
  end

  def test_variables_are_readable
    assert_equal 4, @computer.board_size
    assert_instance_of Board, @computer.board
    assert_instance_of Ship, @computer.ship_array[0]
    assert_instance_of Ship, @computer.ship_array[1]
  end

  def test_ships_get_generated
    assert_instance_of Ship, @computer.generate_ships(@ship_hash)[0]
    assert_instance_of Ship, @computer.generate_ships(@ship_hash)[1]
    assert_nil @computer.generate_ships(@ship_hash)[3]
  end

  def test_turn_outcome
    @player_board = Board.new(4)
    submarine = Ship.new("submarine", 2)
    @player_board.place(submarine, ["A2","A3"])

    expected_miss = "My shot on A1 was a miss"
    expected_hit = "My shot on A2 was a hit"
    expected_sunk = "My shot hit and sunk a ship"

    assert_equal expected_miss, @computer.turn_outcome_computer("A1", @player_board)
    @player_board.board_fire_upon("A2")
    assert_equal expected_hit, @computer.turn_outcome_computer("A2", @player_board)
    @player_board.board_fire_upon("A3")
    assert_equal expected_sunk, @computer.turn_outcome_computer("A3", @player_board)
  end

  def test_computer_lost?
    assert_equal false, @computer.computer_lost?

    ship_hash = {"submarine" => 0, "cruiser" => 0}
    computer = Computer.new(4, ship_hash)

    assert_equal true, computer.computer_lost?
  end
end
