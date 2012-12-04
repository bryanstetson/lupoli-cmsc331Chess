require 'Piece'

class Pawn < Piece
  
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
      
      s += " Pawn"
    end
  
end