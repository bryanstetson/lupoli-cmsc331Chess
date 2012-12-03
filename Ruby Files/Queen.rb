class Queen < Piece
  
  def initialize(col, x, y)
      super.initialize(col, x, y)
      @diagonal = true
      @linear = true
    end
end