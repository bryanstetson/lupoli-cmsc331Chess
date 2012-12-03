class Board
  WHITE = 1
  BLACK = 0
  
  attr_accessor :board, :previous
  
  def initialize()
    @previous = nil
    @board = Array.new(8, Array.new(8))  
    
    @board[0][0], @board[0][7] = Rook.new(WHITE, 0, 0), Rook.new(WHITE, 0, 7)
    @board[7][0], @board[7][7] = Rook.new(BLACK, 7, 0), Rook.new(BLACK, 7, 7)
    
    @board[0][1], @board[0][6] = Knight.new(WHITE, 0, 1), Knight.new(WHITE, 0, 6)
    @board[7][1], @board[7][6] = Knight.new(BLACK, 7, 1), Knight.new(BLACK, 7, 6)
    
    @board[0][2], @board[0][5] = Bishop.new(WHITE, 0, 2), Bishop.new(WHITE, 0, 5)
    @board[7][2], @board[7][5] = Bishop.new(BLACK, 7, 2), Bishop.new(BLACK, 7, 5)
    
    @board[0][3], @board[7][3] = Queen.new(WHITE, 0, 3), Queen.new(BLACK, 7, 3)
    @board[0][4], @board[7][4] = King.new(WHITE, 0, 4), King.new(BLACK, 7, 4)
    
    for i in 0..7
      @board[1][i] = Pawn.new(WHITE, 1, i)
      @board[6][i] = Pawn.new(BLACK, 6, i)
    end
    
  end
  
  def getPieceMoves(x, y)
    if @board[x][y] != nil
      piece = @board[x][y]
      moves = Array.new
      
      if piece.diagonal
        moves.insert(getDiagonal(piece))
      end
        
      if piece.linear
        moves.insert(getLinear(piece))
      end
      
      if piece.special
        moves.insert(getSpecial(piece))
      end
      
      moves
    end
  end
  
  def getDiagonal(piece)
    diagonals = Array.new
    center = piece.pos
    
    pos = center.rightUp
    space = @board[pos.x][pos.y]
    while (space == nil or space.col != piece.col) and pos != nil
      pos = pos.rightUp
      space = @board[pos.x][pos.y]
      diagonals.insert(pos)
    end
    
    pos = center.leftUp
    space = @board[pos.x][pos.y]
    while (space == nil or space.col != piece.col) and pos != nil
      pos = pos.leftUp
      space = @board[pos.x][pos.y]
      diagonals.insert(pos)
    end
    
    pos = center.rightDown
    space = @board[pos.x][pos.y]
    while (space == nil or space.col != piece.col) and pos != nil
      pos = pos.rightDown
      space = @board[pos.x][pos.y]
      diagonals.insert(pos)
    end
    
    pos = center.leftDown
    space = @board[pos.x][pos.y]
    while (space == nil or space.col != piece.col) and pos != nil
      pos = pos.leftDown
      space = @board[pos.x][pos.y]
      diagonals.insert(pos)
    end
    
    diagonals
  end
  
  def getLinear(piece)
    lines = Array.new
    center = piece.pos
    
    pos = center.up
    space = @board[pos.x][pos.y]
    while (space == nil or space.col != piece.col) and pos != nil
      pos = pos.up
      space = @board[pos.x][pos.y]
      lines.insert(pos)
    end
    
    pos = center.down
    space = @board[pos.x][pos.y]
    while (space == nil or space.col != piece.col) and pos != nil
      pos = pos.down
      space = @board[pos.x][pos.y]
      lines.insert(pos)
    end
    
    pos = center.right
    space = @board[pos.x][pos.y]
    while (space == nil or space.col != piece.col) and pos != nil
      pos = pos.right
      space = @board[pos.x][pos.y]
      lines.insert(pos)
    end
    
    pos = center.left
    space = @board[pos.x][pos.y]
    while (space == nil or space.col != piece.col) and pos != nil
      pos = pos.left
      space = @board[pos.x][pos.y]
      lines.insert(pos)
    end
    
    lines
  end
  
  def pawn(piece)
    moves = Array.new
    pos = piece.pos
    
    if piece.col == WHITE
      pos = pos.up
    else
      pos = pos.down
    end
          
    left = pos.left
    right = pos.right 
          
    if @board[pos.x][pos.y] == nil
      moves.insert(pos)
    end
    
    if @board[left.x][left.y] != nil and @board[left.x][left.y].col != piece.col or previous.pos == piece.pos.left 
      moves.insert(left)
    end
          
    if @board[right.x][right.y] != nil and @board[right.x][right.y].col != piece.col or previous.pos == piece.pos.right 
      moves.insert(right)
    end
    
    moves
  end
  
  def getSpecial(piece)
    moves = Array
    if(piece.class == Pawn)
      moves = pawn(piece)
    else
      moves = piece.getSpecialMoves
      
      for pos in moves
        if @board[pos.x][pos.y] != nil and @board[pos.x][pos.y].col == piece.col
          moves.delete(pos)
        end
      end
    end
    
    moves
  end
  
end