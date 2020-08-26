require "./lib/cell"
class Board
  attr_reader :cells
  def initialize
    @cells = Hash.new

    ("A".."D").each do |letter|
      (1..4).each do |number|
        @cells["#{letter + number.to_s}"] = Cell.new("#{letter + number.to_s}")
      end
    end
  end
end
