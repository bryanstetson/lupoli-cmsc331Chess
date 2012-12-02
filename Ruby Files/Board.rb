class Board
  WHITE = 1
  BLACK = 0
  
  attr_accessor :board
  
  def initialize()
    
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
    available = Array
    if @board[x][y] != nil
      for pos in @board[x][y].availableMoves()
        if @board[pos.x()][pos.y()] == nil
          available.insert(pos)
        end
      end
    end
  end
  
end