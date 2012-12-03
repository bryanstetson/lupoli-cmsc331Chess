class Rook < Piece
  
  def initialize(col, x, y)
      super.initialize(col, x, y)
      @linear = true
    end
    
end