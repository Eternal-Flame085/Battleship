require "minitest/autorun"
require "minitest/pride"
require "./lib/cell"

class CellTest < Minitest::Test

  def test_it_exists
    cell = Cell.new("B4")

    assert_instance_of Cell, cell
  end

  def  test_checks_variables_are_readable
     cell = Cell.new("B4")

     assert_equal "B4", cell.coordinate
     assert_nil cell.ship
  end

  def test_if_cell_is_empty?
    cell = Cell.new("B4")

    assert_equal true, cell.empty?
  end

end
