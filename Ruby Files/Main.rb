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
  
  def select(x, y)
    moves = @board.getPieceMoves(x, y)
    #@board.move(x, y, moves[0])
  end
end

Test = Main.new
Test.print
Test.select(0, 1)
#Test.print

