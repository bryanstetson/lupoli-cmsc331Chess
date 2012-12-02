class Coord
  MAX = 7
  
  attr_accessor :x, :y
  
  def initialize(x, y)
    @x = x
    @y = y
  end
  
  def up()
    if @y < MAX
      Coord.new(@x, @y + 1)
    end
  end
  
  def down()
    if @y > 0
      Coord.new(@x, @y - 1)
    end
  end
  
  def left()
    if @x > 0
      Coord.new(@x - 1, @y)
    end
  end
  
  def right()
    if @x < MAX
      Coord.new(@x + 1, @y)
    end
  end
  
  def rightUp()
    if @x < MAX and @y < MAX
      Coord.new(@x + 1, @y + 1)
    end
  end
  
  def rightDown()
    if @x < MAX and @y > 0
      Coord.new(@x + 1, @y - 1)
    end
  end
  
  def leftUp()
    if @x > 0 and @y < MAX
      Coord.new(@x - 1, @y + 1)
    end
  end
  
  def leftDown()
    if @x > 0 and @y > 0
      Coord.new(@x - 1, @y - 1)
    end
  end
  
end