require 'Board'
require 'Coord'

class Main
  
  attr_accessor :board, :chess
  
  def initialize()
    @board = Board.new()
    #@chess = Window.new
  end
  
  def print
    @board.print
  end
  
  def select(r, c)
    moves = @board.getPieceMoves(r, c)
    @board.move(r, c, moves[0])
  end
end

test = Main.new
test.print
for i in 0..7
  test.select(1, i)
  test.print
end


