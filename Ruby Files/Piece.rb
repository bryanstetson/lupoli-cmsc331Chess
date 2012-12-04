require 'Coord'

class Piece
  
  attr :col, :pos, :diagonal, :linear, :special, :moved
  
  def initialize(col, x, y)
    @col = col
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