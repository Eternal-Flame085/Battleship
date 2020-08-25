require './lib/ship'
require 'minitest/autorun'
require 'minitest/pride'

class ShipTest <Minitest::Test

  def test_ship_exists

    ship = Ship.new("Cruiser", 3)
    assert_instance_of Ship, ship
  end

  def test_ship_name_length_health

    ship = Ship.new("Cruiser", 3)

    assert_equal "Cruiser", ship.name
    assert_equal 3, ship.length
    assert_equal 3, ship.health

    end

    def test_ship_sunk

    ship = Ship.new("Cruiser", 3)

    assert_equal false, ship.sunk?
  end

  def test_ship_hit

    ship = Ship.new("Cruiser", 3)
    ship.hit

    assert_equal 2, ship.health
    ship.hit
    assert_equal 1, ship.health
    assert_equal false, ship.sunk?
    ship.hit
    assert_equal true, ship.sunk?
  end
end
