require 'Piece'

class Pawn < Piece
  
  def initialize(col, x, y)
      super(col, x, y)
      @special = true
    end
    
  def to_s
      if @color == 1
        s = "White"
      else
        s = "Black"
      end
      
      s += " Pawn"
    end
    
  def getSpecialMoves
    moves = Array.new
    
    if @color == 1
      moves = [@pos.up, @pos.leftUp, @pos.rightUp]
      if !@moved
        moves += [@pos.up.up]
      end
    else
      moves = [@pos.down, @pos.leftDown, @pos.rightDown]
      if !@moved
        moves += [@pos.down.down]
      end
    end
    
    moves
  end
  
end

#test = Pawn.new(1, 1, 1)
#moves = test.getSpecialMoves()
#for m in moves
#  puts m
#end