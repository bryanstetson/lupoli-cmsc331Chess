require 'Piece'

class Knight < Piece
  
    def initialize(col, x, y)
      super(col, x, y)
      @special = true
    end
    
  def to_s
      if @col == 1
        s = "White"
      else
        s = "Black"
      end
      
      s += " Knight"
    end
    
    def getSpecialMoves
      moves = Array.allocate()
      
      lu = @pos.leftUp
      if lu != nil
        moves.insert(-1, lu.up, lu.left)
      end
      
      ld = @pos.leftDown
      if ld != nil
        moves.insert(-1, ld.left, ld.down)
      end
      
      ru = @pos.rightUp
      if ru != nil
        moves.insert(-1, ru.right, ru.up)
      end
      
      rd = @pos.rightDown
      if rd != nil
        moves.insert(-1, rd.right, rd.down)
      end
      
      moves
    end
    
end