require 'Piece'

class King < Piece
  
  @check
  
  def initialize(col, x, y)
    super(col, x, y)
    @special = true
    @check = false
  end
  
  def to_s
    if @color == 1
      s = "White"
    else
      s = "Black"
    end
    
    s += " King"
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

#test = King.new(0, 0, 4)
#moves = test.getSpecialMoves()
#puts moves