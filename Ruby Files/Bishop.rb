require 'Piece'

class Bishop < Piece
  
  def initialize(col, x, y)
      super(col, x, y)
      @diagonal = true
    end
    
  def to_s
      if @color == 1
        s = "White"
      else
        s = "Black"
      end
      
      s += " Bishop"
    end
  
end