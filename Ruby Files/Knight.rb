class Knight < Piece
  
    def initialize(col, x, y)
      super.initialize(col, x, y)
      @special = true
    end
    
    def getSpecialMoves
      moves = Array.new
      
      lu = @pos.leftUp
      if lu != nil
        moves.insert(lu.up, lu.left)
      end
      
      ld = @pos.leftDown
      if ld != nil
        moves.insert(ld.left, ld.down)
      end
      
      ru = @pos.rightUp
      if ru != nil
        moves.insert(ru.right, ru.up)
      end
      
      rd = @pos.rightDown
      if rd != nil
        moves.insert(rd.right, rd.down)
      end
      
      moves
    end
    
end