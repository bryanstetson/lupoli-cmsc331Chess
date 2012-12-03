class Pawn < Piece
  
  def initialize(col, x, y)
      super.initialize(col, x, y)
      @special = true
    end
  
end