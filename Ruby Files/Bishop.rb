class Bishop < Piece
  
  def initialize(col, x, y)
      super.initialize(col, x, y)
      @diagonal = true
    end
  
end