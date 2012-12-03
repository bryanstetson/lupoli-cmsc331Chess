class King < Piece
  
  @check = false
  
  def initialize(col, x, y)
    super.initialize(col, x, y)
    @special = true
  end
  
  def getSpecialMoves
    [@pos.leftUp, @pos.up, @pos.rightUp, @pos.left, @pos.right, @pos.leftDown, @pos.down, @pos.rightDown]
  end
  
  def inCheck()
    @check
  end
  
  def check()
    @check = true
  end
  
  def unCheck()
    @check = false
  end
    
end