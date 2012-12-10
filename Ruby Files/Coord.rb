class Coord
  MAX = 7
  
  attr_accessor :row, :col
  
  def initialize(r, c)
    @row = r
    @col = c
  end
  
  def == (other)
    if other == nil or other.class != self.class or @row != other.row or @col != other.col
      return false
    end
    
    true
  end
  
  def to_s
    "(" + @row.to_s + ", " + @col.to_s + ")"
  end
  
  def up()
    if @row < MAX
      Coord.new(@row + 1, @col)
    end
  end
  
  def down()
    if @row > 0
      Coord.new(@row - 1, @col)
    end
  end
  
  def left()
    if @col > 0
      Coord.new(@row, @col - 1)
    end
  end
  
  def right()
    if @col < MAX
      Coord.new(@row, @col + 1)
    end
  end
  
  def rightUp()
    if @row < MAX and @col < MAX
      Coord.new(@row + 1, @col + 1)
    end
  end
  
  def rightDown()
    if @col < MAX and @row > 0
      Coord.new(@row - 1, @col + 1)
    end
  end
  
  def leftUp()
    if @col > 0 and @row < MAX
      Coord.new(@row + 1, @col - 1)
    end
  end
  
  def leftDown()
    if @row > 0 and @col > 0
      Coord.new(@row - 1, @col - 1)
    end
  end
  
end