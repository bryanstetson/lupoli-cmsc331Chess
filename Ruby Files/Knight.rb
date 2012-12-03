class Knight < Piece
  
    def initialize(col, x, y)
      super.initialize(col, x, y)
      @special = true
    end
    
    def getSpecialMoves
      lu = @pos.leftUp
      ld = @pos.leftDown
      ru = @pos.rightUp
      rd = @pos.rightDown
      
      [lu.up, lu.left, ru.up, ru.right, ld.left, ld.down, rd.right, rd.down]
    end
    
end