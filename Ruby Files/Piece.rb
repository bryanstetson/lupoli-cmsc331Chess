require 'Coord'

class Piece
  
  attr :color, :pos, :diagonal, :linear, :special, :moved
  
  def initialize(col, x, y)
    @color = col
    @pos = Coord.new(x,y)
    @diagonal = false
    @linear = false
    @special = false
    @moved = false
  end
  
  def move(pos)
    @pos = pos
    @moved = true
  end
  
end