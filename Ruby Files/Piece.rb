class Piece
  
  attr_accessor :col
  
  def initialize(col, x, y)
    @col = col
    @pos = Coord.new(x,y)
  end
  
  def move(pos)
    @pos = pos
  end
  
end