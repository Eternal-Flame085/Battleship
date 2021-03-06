require "minitest/autorun"
require "minitest/pride"
require "./lib/board"
require "./lib/cell"
require "./lib/ship"

class BoardTest < Minitest::Test
  def test_it_exists
    board = Board.new(4)

    assert_instance_of Board, board
  end

  def test_creating_the_board_cells
    board = Board.new(4)

    assert_instance_of Hash, board.cells
    assert_equal 16, board.cells.length
    assert_instance_of Cell, board.cells.values.first
  end

  def test_board_valid
    board = Board.new(4)

    assert_equal true, board.valid_coordinate?("A1")
    assert_equal true, board.valid_coordinate?("D4")
    assert_equal false, board.valid_coordinate?("A5")
    assert_equal false, board.valid_coordinate?("E1")
    assert_equal false, board.valid_coordinate?("A22")
  end

  def test_length_placements
    board = Board.new(4)
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    assert_equal false, board.valid_placement?(cruiser, ["A1", "A2"])
    assert_equal false, board.valid_placement?(submarine, ["A2", "A3", "A4"])

  end

  def test_consecutive_placement
    board = Board.new(4)
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    assert_equal false, board.horizontal_validation?("A1","A4",cruiser)
    # assert_equal false, board.valid_placement?(submarine, ["A1", "C1"])
    # assert_equal false, board.valid_placement?(cruiser, ["A3", "A2", "A1"])
    # assert_equal false, board.valid_placement?(submarine, ["C1", "B1"])
    # assert_equal true, board.valid_placement?(cruiser, ["A1", "A2", "A3"])
    # assert_equal false, board.valid_placement?(cruiser, ["A3", "A4", "A5"])
  end

  def test_coordinates_diagonal
    board = Board.new(4)
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    assert_equal false, board.valid_placement?(cruiser, ["A1", "B2", "C3"])
    assert_equal false, board.valid_placement?(submarine, ["C2", "D3"])
  end

  def test_valid_placements
    board = Board.new(4)
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    assert_equal true, board.valid_placement?(submarine, ["A1", "A2"])
    assert_equal true, board.valid_placement?(cruiser, ["B1", "C1", "D1"])
  end

  def test_cells_have_same_ship
    board = Board.new(4)
    cruiser = Ship.new("Cruiser", 3)

    board.place(cruiser, ["A1", "A2", "A3"])

    cell_1 = board.cells["A1"]
    cell_2 = board.cells["A2"]
    cell_3 = board.cells["A3"]

    assert_equal cruiser, cell_1.ship
    assert_equal cruiser, cell_2.ship
    assert_equal cruiser, cell_3.ship
  end

  def test_overlapping_ships
    board = Board.new(4)
    cruiser = Ship.new("Cruiser", 3)

    board.place(cruiser, ["A1", "A2", "A3"])

    submarine = Ship.new("Submarine", 2)

    assert_equal false, board.overlaping_ship?(["A1","B1"])
    assert_equal false, board.valid_placement?(submarine, ["A1","B1"])
  end

  def test_board_renders
    board = Board.new(4)
    cruiser = Ship.new("Cruiser", 3)

    board.place(cruiser, ["A1", "A2", "A3"])

    expected = "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
    expected_2 = "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n"

    assert_equal expected, board.render
    assert_equal expected_2, board.render(true)
  end

  def test_if_board_can_call_fired_upon
    board = Board.new(4)

    assert_equal false, board.board_fired_upon?("B3")

    board.cells["B3"].fire_upon
    assert_equal true, board.board_fired_upon?("B3")
  end

  def test_if_board_can_call_fire_upon
    board = Board.new(4)

    assert_equal false, board.board_fired_upon?("B3")

    board.board_fire_upon("B3")
    assert_equal true, board.board_fired_upon?("B3")
  end
end
