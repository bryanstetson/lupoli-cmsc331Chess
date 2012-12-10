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
  
  def ==(other)
    if other == nil or other.class != self.class or other.color != @color or other.pos != @pos
      return false
    end
    
    true
  end
end