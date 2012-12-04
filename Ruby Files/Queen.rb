require 'Piece'

class Queen < Piece
  
  def initialize(col, x, y)
      super(col, x, y)
      @diagonal = true
      @linear = true
    end
    
  def to_s
      if @col == 1
        s = "White"
      else
        s = "Black"
      end
      
      s += " Queen"
    end
end