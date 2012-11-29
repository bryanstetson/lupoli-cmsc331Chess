class Board
  
  def initialize()
    @board = Array.new(8, Array.new(8, NULL));
      
    @board[0][0] = Rook.new()
  end
  
  
end