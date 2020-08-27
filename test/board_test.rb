require "minitest/autorun"
require "minitest/pride"
require "./lib/board"
require "./lib/cell"
require "./lib/ship"

class BoardTest < Minitest::Test
  def test_it_exists
    board = Board.new

    assert_instance_of Board, board
  end

  def test_creating_the_board_cells
    board = Board.new

    assert_instance_of Hash, board.cells
    assert_equal 16, board.cells.length
    assert_instance_of Cell, board.cells.values.first
  end

  def test_board_valid
    board = Board.new

    assert_equal true, board.valid_coordinate?("A1")
    assert_equal true, board.valid_coordinate?("D4")
    assert_equal false, board.valid_coordinate?("A5")
    assert_equal false, board.valid_coordinate?("E1")
    assert_equal false, board.valid_coordinate?("A22")
  end
def test_length_placements

  board = Board.new
  cruiser = Ship.new("Cruiser", 3)
  submarine = Ship.new("Submarine", 2)

  assert_equal false, board.valid_placement?(cruiser, ["A1", "A2"])
  assert_equal false, board.valid_placement?(submarine, ["A2", "A3", "A4"])

  end

def test_consecutive_placement

  board = Board.new
  cruiser = Ship.new("Cruiser", 3)
  submarine = Ship.new("Submarine", 2)

  assert_equal false, board.valid_placement?(cruiser, ["A1", "A2", "A4"])
  assert_equal false, board.valid_placement?(submarine, ["A1", "C1"])
  assert_equal false, board.valid_placement?(cruiser, ["A3", "A2", "A1"])
  assert_equal false, board.valid_placement?(submarine, ["C1", "B1"])
  assert_equal true, board.valid_placement?(cruiser, ["A1", "A2", "A3"])
  end
end
