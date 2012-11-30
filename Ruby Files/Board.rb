class Board
  WHITE = 1
  BLACK = 0
  
  def initialize()
    
    board = Array.new(8, Array.new(8, NULL))  
    
    board[0][0], board[0][7] = Rook.new(WHITE)
    board[7][0], board[7][7] = Rook.new(BLACK)
    
    board[0][1], board[0][6] = Knight.new(WHITE)
    board[7][1], board[7][6] = Knight.new(BLACK)
    
    board[0][2], board[0][5] = Bishop.new(WHITE)
    board[7][2], board[7][5] = Bishop.new(BLACK)
    
    board[0][3], board[7][3] = Queen.new(WHITE), Queen.new(BLACK)
    board[7][4], board[7][4] = King.new(WHITE), King.new(BLACK)
    
    for i in 0..7
      board[1][i] = Pawn.new(WHITE)
      board[6][i] = Pawn.new(BLACK)
    end
    
  end
  
  
end