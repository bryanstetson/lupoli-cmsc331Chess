require 'Piece'

class Rook < Piece
  
  def initialize(col, x, y)
      super(col, x, y)
      @linear = true
    end
    
  def to_s
      if @color == 1
        s = "White"
      else
        s = "Black"
      end
      
      s += " Rook"
    end
    
end