require "minitest/autorun"
require "minitest/pride"
require "./lib/board"
require "./lib/ship"
require "./lib/cell"
require "./lib/computer"
require "./lib/player"
require 'mocha/minitest'

class PlayerTest <Minitest::Test

  def test_it_exists

    @ship_hash = {"submarin" => 2, "cruiser" => 3}
    @player = Player.new(4, @ship_hash)

    assert_instance_of Player, @player
  end

  def test_variables_exist

    @ship_hash = {"submarin" => 2, "cruiser" => 3}
    @player = Player.new(4, @ship_hash)

    assert_equal 4, @player.board_size
    assert_instance_of Board, @player.board
    assert_instance_of Ship, @player.ship_array[0]
    assert_instance_of Ship, @player.ship_array[1]
  end

  def test_ships_get_generated

    @ship_hash = {"submarin" => 2, "cruiser" => 3}
    @player = Player.new(4, @ship_hash)

    assert_instance_of Ship, @player.generate_ships(@ship_hash)[0]
    assert_instance_of Ship, @player.generate_ships(@ship_hash)[1]
    assert_nil @player.generate_ships(@ship_hash)[2]
  end

  def test_player_lost

    @ship_hash = {"submarine" => 2, "cruiser" => 3}
    @player = Player.new(4, @ship_hash)

    assert_equal false, @player.player_lost?

    @ship_hash = {"submarine" => 0, "cruiser" => 0}
    @player = Player.new(4, @ship_hash)

    assert_equal true, @player.player_lost?
  end

  def test_turn_outcome_player

    @ship_hash = {"submarine" => 2, "cruiser" => 3}
    @player = Player.new(4, @ship_hash)
    @computer_board = Board.new(4)
    submarine = Ship.new("submarine", 2)
    expected_miss = "Your shot on A1 was a miss"


    assert_equal expected_miss, @player.turn_outcome_player("A1", @computer_board)

    @ship_hash = {"submarine" => 2, "cruiser" => 3}
    @player = Player.new(4, @ship_hash)
    @computer_board = Board.new(4)
    submarine = Ship.new("submarine", 2)
    expected_hit = "Your shot on A1 was a hit"
    @computer_board.place(submarine, ["A1", "A2"])

    assert_equal expected_hit, @player.turn_outcome_player("A1", @computer_board)
  end
end
